-- Game rules in SQL: truth zone, scoring, lifecycle guards, early and timed reveal.
-- Run: supabase test db   (or scripts/db/test-local.sh without Docker)
begin;
create extension if not exists pgtap with schema extensions;
select plan(25);

-- ---------- fixture: A speaks, B C D read, E is an outsider ----------
insert into auth.users (id, email) values
  ('a0000000-0000-0000-0000-000000000000', 'a@test.blag'), ('b0000000-0000-0000-0000-000000000000', 'b@test.blag'),
  ('c0000000-0000-0000-0000-000000000000', 'c@test.blag'), ('d0000000-0000-0000-0000-000000000000', 'd@test.blag'),
  ('e0000000-0000-0000-0000-000000000000', 'e@test.blag');
insert into identity.profiles (user_id, display_name, age_attested_at, age_gate_version)
  select id, upper(left(email, 1)), now(), 'v1' from auth.users where email like '%@test.blag';
insert into game.stat_catalog values ('ST-01', 'screen_time_minutes', 'minutes', 0, 1440, 15, false, true);
insert into circles.circles (id, name, timezone, created_by)
  values ('11111111-1111-1111-1111-111111111111', 'Hostel 4', 'Asia/Kolkata', 'a0000000-0000-0000-0000-000000000000');
insert into circles.members (circle_id, user_id, role)
  select '11111111-1111-1111-1111-111111111111', id,
         case when email = 'a@test.blag' then 'organiser'::circles.member_role else 'member' end
  from auth.users where email in ('a@test.blag', 'b@test.blag', 'c@test.blag', 'd@test.blag');
insert into league.seasons (id, circle_id, starts_on, ends_on, status)
  values ('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111',
          current_date - 1, current_date + 27, 'active');
insert into game.rounds (id, circle_id, season_id, play_date, slot, state, stat_id, prompt_key, speaker_id, seed,
                         opens_at, speaker_cutoff_at, backup_cutoff_at, reveal_at)
values
  ('33333333-3333-3333-3333-333333333331', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222',
   current_date, 1, 'open', 'ST-01', 'stat.screen_time', 'a0000000-0000-0000-0000-000000000000', 'seed-0123456789abcdef',
   now() - interval '1 hour', now() + interval '1 hour', now() + interval '2 hours', now() + interval '3 hours'),
  ('33333333-3333-3333-3333-333333333332', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222',
   current_date, 2, 'open', 'ST-01', 'stat.screen_time', 'b0000000-0000-0000-0000-000000000000', 'seed-abcdef0123456789',
   now() - interval '1 hour', now() + interval '1 hour', now() + interval '2 hours', now() + interval '3 hours');
insert into game.rounds (id, circle_id, season_id, play_date, slot, card_type, rest_reason, state, prompt_key, seed,
                         opens_at, speaker_cutoff_at, backup_cutoff_at, reveal_at)
values ('33333333-3333-3333-3333-333333333333', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222',
        current_date + 1, 1, 'rest', 'rest_day', 'rest', 'rest.tea_or_coffee', 'seed-restrestrestrest',
        now() - interval '1 hour', now() + interval '1 hour', now() + interval '2 hours', now() + interval '3 hours');

-- ---------- truth zone: h = max(ceil(0.10 x seal), floor) ----------
select is((select row(zone_min, zone_max)::text from game.truth_zone(180, 15)), '(162,198)', '180 min: 10% beats the 15 floor');
select is((select row(zone_min, zone_max)::text from game.truth_zone(100, 15)), '(85,115)',  '100 min: the 15 floor wins');
select is((select row(zone_min, zone_max)::text from game.truth_zone(0, 15)),   '(0,15)',    'zone never goes below zero');
select is((select row(zone_min, zone_max)::text from game.truth_zone(5, 0)),    '(4,6)',     'ceil rounds the 10% up');
select is((select row(zone_min, zone_max)::text from game.truth_zone(9000, 300)), '(8100,9900)', 'steps scale');

-- ---------- guards before play ----------
select throws_ok($$ select game.claim('a0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 240) $$,
                 'P0001', 'seal_first', 'cannot claim before sealing');
select throws_ok($$ select game.seal('b0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 100, 'manual') $$,
                 '42501', 'not_speaker', 'only the Speaker can seal');
select throws_ok($$ select game.seal('a0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 5000, 'manual') $$,
                 '22003', 'value_out_of_range', 'seal must fit the stat range');
select throws_ok($$ select game.cast_read('b0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'truth') $$,
                 'P0001', 'reading_closed', 'no reads before the claim');

-- ---------- round 1: A seals 180, claims 240 (zone 162..198 -> a BLUFF) ----------
select lives_ok($$ select game.seal('a0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 180, 'manual') $$, 'Speaker seals');
select throws_ok($$ select game.seal('a0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 100, 'manual') $$,
                 '23505', 'already_sealed', 'a seal can never be changed');
select lives_ok($$ select game.claim('a0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 240) $$, 'Speaker claims');
select is((select state::text from game.rounds where id = '33333333-3333-3333-3333-333333333331'), 'claimed', 'round is claimed');
select throws_ok($$ select game.cast_read('a0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'truth') $$,
                 '42501', 'speaker_cannot_read', 'Speaker cannot read their own round');
select throws_ok($$ select game.cast_read('e0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'truth') $$,
                 '42501', 'not_member', 'outsiders cannot read');

select game.cast_read('b0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'truth', 300);
select game.cast_read('b0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'bluff', 185);  -- changed mind
select game.cast_read('c0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'truth', 230);
select is((select state::text from game.rounds where id = '33333333-3333-3333-3333-333333333331'), 'claimed', 'not revealed while a reader is missing');
select game.cast_read('d0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'bluff', 175);

-- ---------- early reveal once everyone has read ----------
select is((select state::text from game.rounds where id = '33333333-3333-3333-3333-333333333331'), 'revealed', 'last read reveals early');
select is((select row(revealed_value, truth_min, truth_max, is_truth)::text from game.rounds
           where id = '33333333-3333-3333-3333-333333333331'), '(180,162,198,f)', 'revealed value, zone and verdict stored');
select is((select count(*)::int from private.seals where round_id = '33333333-3333-3333-3333-333333333331'), 0, 'seal deleted at reveal');
select results_eq(
  $$ select p.display_name, rr.points::int from game.round_results rr join identity.profiles p using (user_id)
     where rr.round_id = '33333333-3333-3333-3333-333333333331' order by p.display_name $$,
  $$ values ('A', 1), ('B', 4), ('C', 0), ('D', 4) $$,
  'scores: readers 2+1+1, ties share closest, Speaker min(3, misreads)');
select is((select count(*)::int from pgmq.q where msg->>'round_id' = '33333333-3333-3333-3333-333333333331'), 2,
          'round.revealed queued for league and notifications');

-- ---------- round 2: timed reveal with one read; rest card reveals too ----------
select game.seal('b0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333332', 60, 'manual');
select game.claim('b0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333332', 60);
select game.cast_read('c0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333332', 'truth');
select is(game.reveal_due_rounds(now() + interval '4 hours'), 2, 'scheduler reveals the claimed round and the rest card');
select is((select points::int from game.round_results where round_id = '33333333-3333-3333-3333-333333333332'
           and user_id = 'c0000000-0000-0000-0000-000000000000'), 2, 'correct read without a guess scores 2');

-- ---------- schedule rules (D-29) ----------
select throws_ok($$ insert into circles.schedule_versions (circle_id, effective_from, rounds_per_day, reveal_time_1, reveal_time_2)
                    values ('11111111-1111-1111-1111-111111111111', current_date + 1, 2, '20:00', '21:00') $$,
                 '23514', null, 'two reveals must be at least 3 hours apart');
select lives_ok($$ insert into circles.schedule_versions (circle_id, effective_from, rounds_per_day, reveal_time_1, reveal_time_2)
                   values ('11111111-1111-1111-1111-111111111111', current_date + 1, 2, '14:00', '21:00') $$,
                'two rounds at 14:00 and 21:00 accepted');

select * from finish();
rollback;

-- Access rules: who can see what, and who can run what.
-- Run: supabase test db   (or scripts/db/test-local.sh without Docker)
begin;
create extension if not exists pgtap with schema extensions;
select plan(24);

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
insert into circles.away (circle_id, user_id, starts_on, ends_on)
  values ('11111111-1111-1111-1111-111111111111', 'd0000000-0000-0000-0000-000000000000', current_date + 3, current_date + 5);
insert into league.seasons (id, circle_id, starts_on, ends_on, status)
  values ('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111',
          current_date - 1, current_date + 27, 'active');
insert into game.rounds (id, circle_id, season_id, play_date, slot, state, stat_id, prompt_key, speaker_id, seed,
                         opens_at, speaker_cutoff_at, backup_cutoff_at, reveal_at)
values ('33333333-3333-3333-3333-333333333331', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222',
        current_date, 1, 'open', 'ST-01', 'stat.screen_time', 'a0000000-0000-0000-0000-000000000000', 'seed-0123456789abcdef',
        now() - interval '1 hour', now() + interval '1 hour', now() + interval '2 hours', now() + interval '3 hours');
select game.seal('a0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 180, 'manual');

-- ---------- before the claim: the Speaker is secret (D-15) ----------
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"b0000000-0000-0000-0000-000000000000","role":"authenticated"}', true);
select is((select speaker_id from api.rounds), null, 'B cannot see who is speaking before the claim');
select set_config('request.jwt.claims', '{"sub":"a0000000-0000-0000-0000-000000000000","role":"authenticated"}', true);
select is((select i_am_speaker from api.rounds), true, 'the Speaker knows it is them');
reset role;

select game.claim('a0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 240);
select game.cast_read('b0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'bluff', 185);

-- ---------- B, a member, before the reveal ----------
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"b0000000-0000-0000-0000-000000000000","role":"authenticated"}', true);
select is((select speaker_id from api.rounds), 'a0000000-0000-0000-0000-000000000000'::uuid, 'Speaker visible after the claim');
select is((select count(*)::int from game.reads), 1, 'B sees only their own read');
select is((select count(*)::int from game.round_results), 0, 'no scores before the reveal');
select is((select row(reads_in, readers_total)::text from api.round_progress('33333333-3333-3333-3333-333333333331')),
          '(1,3)', 'progress shows counts only');
select is((select revealed_value from api.rounds), null, 'real number hidden before the reveal');
select throws_ok($$ select * from private.seals $$, '42501', null, 'sealed numbers: permission denied');
select throws_ok($$ select seed from game.rounds $$, '42501', null, 'the pick seed is never readable');
select throws_ok($$ select speaker_attempt from game.rounds $$, '42501', null, 'backup Speaker attempts are never readable');
select throws_ok($$ select timezone from identity.profiles $$, '42501', null, 'other profile columns are not granted');
select throws_ok($$ select game.seal('b0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 1, 'manual') $$,
                 '42501', null, 'the app cannot call write functions directly');
select is((select count(*)::int from circles.away), 0, 'nobody sees another member is away');
select set_config('realtime.topic', 'circle:11111111-1111-1111-1111-111111111111', true);
select ok((select count(*) from realtime.messages) > 0, 'members receive circle broadcasts');

-- ---------- D sees their own away status ----------
select set_config('request.jwt.claims', '{"sub":"d0000000-0000-0000-0000-000000000000","role":"authenticated"}', true);
select is((select count(*)::int from api.my_away), 1, 'a member sees their own away days');

-- ---------- E, an outsider ----------
select set_config('request.jwt.claims', '{"sub":"e0000000-0000-0000-0000-000000000000","role":"authenticated"}', true);
select is((select count(*)::int from api.rounds), 0, 'outsider sees no rounds');
select is((select count(*)::int from api.circle_members), 0, 'outsider sees no members');
select is((select count(*)::int from identity.profiles), 1, 'outsider sees only their own profile');
select is((select count(*)::int from realtime.messages), 0, 'outsider receives no broadcasts');
reset role;

-- ---------- service roles: functions only, no tables ----------
grant usage on schema extensions to svc_game;   -- lets the role call pgTAP itself (rolled back)
set local role svc_game;
select throws_ok($$ select count(*) from game.rounds $$, '42501', null, 'svc_game cannot read tables');
select throws_ok($$ select game.reveal_due_rounds(now()) $$, '42501', null, 'svc_game cannot run the scheduler');
reset role;

-- ---------- after everyone reads, B sees everything ----------
select game.cast_read('c0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'truth', 230);
select game.cast_read('d0000000-0000-0000-0000-000000000000', '33333333-3333-3333-3333-333333333331', 'bluff', 175);
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"b0000000-0000-0000-0000-000000000000","role":"authenticated"}', true);
select is((select count(*)::int from game.reads), 3, 'all reads visible after the reveal');
select is((select count(*)::int from api.round_results), 4, 'all scores visible after the reveal');
select is((select revealed_value from api.rounds), 180, 'real number visible after the reveal');
reset role;

select * from finish();
rollback;

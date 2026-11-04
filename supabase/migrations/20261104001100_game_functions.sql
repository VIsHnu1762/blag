-- BLAG migration 11: game rules in SQL and the game write functions
-- The rules must match @blag/game-engine exactly; the same test cases run
-- against both (D-44). Errors raise stable keys mapped by @blag/contracts.
--
-- Write functions are called ONLY by the owning service's Edge Function,
-- which has already verified the caller's JWT and passes them as p_actor.

-- h = max(ceil(0.10 x seal), floor);  zone = [seal - h, seal + h]   (D-28)
create function game.truth_zone(p_seal integer, p_floor integer,
                                out zone_min integer, out zone_max integer)
language sql immutable set search_path = ''
as $$
  select greatest(0, p_seal - h), p_seal + h
  from (select greatest(ceil(0.10 * p_seal)::integer, p_floor) as h) s
$$;

-- Score on write (D-22): rebuilds one round's provisional results (<= 7 readers).
-- reader  = 2 x correct read + 1 x closest guess (ties all score) + 1 x guess in zone
-- speaker = min(3, misreads)
create function game.recompute_results(p_round uuid)
returns void language plpgsql security definer set search_path = ''
as $$
declare
  v_round    game.rounds%rowtype;
  v_seal     integer;
  v_floor    integer;
  v_min      integer;
  v_max      integer;
  v_is_truth boolean;
  v_best     integer;
begin
  select * into v_round from game.rounds where id = p_round;
  if v_round.card_type <> 'stat' or v_round.claim is null then return; end if;

  select s.value into v_seal from private.seals s where s.round_id = p_round;
  if v_seal is null then return; end if;

  select c.floor_h into v_floor from game.stat_catalog c where c.stat_id = v_round.stat_id;
  select z.zone_min, z.zone_max into v_min, v_max from game.truth_zone(v_seal, v_floor) z;
  v_is_truth := v_round.claim between v_min and v_max;

  select min(abs(r.guess - v_seal)) into v_best
  from game.reads r where r.round_id = p_round and r.guess is not null;

  delete from game.round_results where round_id = p_round;

  insert into game.round_results (round_id, user_id, is_speaker, correct, closest, in_zone, points)
  select p_round, r.reader_id, false, x.correct, x.closest, x.in_zone,
         (2 * x.correct::int + x.closest::int + x.in_zone::int)::smallint
  from game.reads r
  cross join lateral (select
      (r.verdict = 'truth') = v_is_truth                                       as correct,
      coalesce(r.guess is not null and abs(r.guess - v_seal) = v_best, false) as closest,
      coalesce(r.guess between v_min and v_max, false)                         as in_zone) x
  where r.round_id = p_round;

  if v_round.speaker_id is not null then
    insert into game.round_results (round_id, user_id, is_speaker, misreads, points)
    select p_round, v_round.speaker_id, true,
           count(*) filter (where (r.verdict = 'truth') <> v_is_truth)::smallint,
           least(3, count(*) filter (where (r.verdict = 'truth') <> v_is_truth))::smallint
    from game.reads r where r.round_id = p_round;
  end if;
end $$;

-- The current Speaker may act until their own cutoff.
create function game.speaker_deadline(p_round game.rounds)
returns timestamptz language sql immutable set search_path = ''
as $$ select case p_round.speaker_attempt when 1 then p_round.speaker_cutoff_at
                                         else p_round.backup_cutoff_at end $$;

create function game.seal(p_actor uuid, p_round uuid, p_value integer, p_method game.input_method)
returns void language plpgsql security definer set search_path = ''
as $$
declare v_round game.rounds%rowtype; v_cat game.stat_catalog%rowtype;
begin
  select * into v_round from game.rounds where id = p_round for update;
  if not found then raise exception 'round_not_found' using errcode = 'P0002'; end if;
  if v_round.speaker_id is distinct from p_actor then raise exception 'not_speaker' using errcode = '42501'; end if;
  if v_round.state <> 'open' or now() >= game.speaker_deadline(v_round) then
    raise exception 'speaker_window_closed' using errcode = 'P0001';
  end if;
  select * into v_cat from game.stat_catalog where stat_id = v_round.stat_id;
  if p_value not between v_cat.min_value and v_cat.max_value then
    raise exception 'value_out_of_range' using errcode = '22003';
  end if;
  if exists (select 1 from private.seals where round_id = p_round) then
    raise exception 'already_sealed' using errcode = '23505';
  end if;
  insert into private.seals (round_id, speaker_id, value, input_method)
  values (p_round, p_actor, p_value, p_method);
end $$;

create function game.claim(p_actor uuid, p_round uuid, p_claim integer)
returns void language plpgsql security definer set search_path = ''
as $$
declare v_round game.rounds%rowtype; v_cat game.stat_catalog%rowtype;
begin
  select * into v_round from game.rounds where id = p_round for update;
  if not found then raise exception 'round_not_found' using errcode = 'P0002'; end if;
  if v_round.speaker_id is distinct from p_actor then raise exception 'not_speaker' using errcode = '42501'; end if;
  if v_round.state <> 'open' or now() >= game.speaker_deadline(v_round) then
    raise exception 'speaker_window_closed' using errcode = 'P0001';
  end if;
  if not exists (select 1 from private.seals where round_id = p_round) then
    raise exception 'seal_first' using errcode = 'P0001';
  end if;
  select * into v_cat from game.stat_catalog where stat_id = v_round.stat_id;
  if p_claim not between v_cat.min_value and v_cat.max_value then
    raise exception 'value_out_of_range' using errcode = '22003';
  end if;
  update game.rounds set claim = p_claim, claimed_at = now(), state = 'claimed' where id = p_round;
  perform realtime.send(jsonb_build_object('type', 'round.claimed', 'round_id', p_round),
                        'round.claimed', 'circle:' || v_round.circle_id::text, true);
end $$;

-- Reveal a set of rounds in one statement each. Results already exist, so this
-- is a state flip + seal purge + events + one tiny realtime ping per round.
create function game.reveal_rounds(p_ids uuid[], p_now timestamptz default now())
returns integer language plpgsql security definer set search_path = ''
as $$
declare v_stat uuid[]; v_rest uuid[]; v_all uuid[];
begin
  with flipped as (
    update game.rounds r
       set state          = 'revealed',
           revealed_at    = p_now,
           revealed_value = s.value,
           truth_min      = z.zone_min,
           truth_max      = z.zone_max,
           is_truth       = r.claim between z.zone_min and z.zone_max
      from private.seals s, game.stat_catalog c,
           lateral game.truth_zone(s.value, c.floor_h) z
     where r.id = any (p_ids) and r.state = 'claimed'
       and s.round_id = r.id and c.stat_id = r.stat_id
    returning r.id
  )
  select coalesce(array_agg(id), '{}') into v_stat from flipped;

  with flipped as (
    update game.rounds r set state = 'revealed', revealed_at = p_now
     where r.id = any (p_ids) and r.state = 'rest'
    returning r.id
  )
  select coalesce(array_agg(id), '{}') into v_rest from flipped;

  v_all := v_stat || v_rest;
  if cardinality(v_all) = 0 then return 0; end if;

  delete from private.seals where round_id = any (v_stat);   -- data minimisation

  if cardinality(v_stat) > 0 then
    perform pgmq.send_batch('league_inbox', (
      select array_agg(jsonb_build_object('type', 'round.revealed', 'v', 1, 'round_id', r.id,
               'circle_id', r.circle_id, 'season_id', r.season_id, 'play_date', r.play_date))
      from game.rounds r where r.id = any (v_stat)));
  end if;
  perform pgmq.send_batch('notify_inbox', (
    select array_agg(jsonb_build_object('type', 'round.revealed', 'v', 1, 'round_id', r.id,
             'circle_id', r.circle_id, 'card_type', r.card_type))
    from game.rounds r where r.id = any (v_all)));

  perform realtime.send(jsonb_build_object('type', 'round.revealed', 'round_id', r.id),
                        'round.revealed', 'circle:' || r.circle_id::text, true)
  from game.rounds r where r.id = any (v_all);

  return cardinality(v_all);
end $$;

create function game.cast_read(p_actor uuid, p_round uuid, p_verdict game.verdict, p_guess integer default null)
returns void language plpgsql security definer set search_path = ''
as $$
declare v_round game.rounds%rowtype; v_cat game.stat_catalog%rowtype; v_reads int; v_readers int;
begin
  select * into v_round from game.rounds where id = p_round for update;
  if not found then raise exception 'round_not_found' using errcode = 'P0002'; end if;
  if not circles.is_active_member(v_round.circle_id, p_actor) then
    raise exception 'not_member' using errcode = '42501';
  end if;
  if v_round.speaker_id = p_actor then raise exception 'speaker_cannot_read' using errcode = '42501'; end if;
  if v_round.state <> 'claimed' or now() >= v_round.reveal_at then
    raise exception 'reading_closed' using errcode = 'P0001';
  end if;
  select * into v_cat from game.stat_catalog where stat_id = v_round.stat_id;
  if p_guess is not null and p_guess not between v_cat.min_value and v_cat.max_value then
    raise exception 'value_out_of_range' using errcode = '22003';
  end if;

  insert into game.reads (round_id, reader_id, verdict, guess)
  values (p_round, p_actor, p_verdict, p_guess)
  on conflict (round_id, reader_id)
  do update set verdict = excluded.verdict, guess = excluded.guess;   -- changeable until reveal

  perform game.recompute_results(p_round);
  -- tiny ping, no verdicts: clients refetch progress (counts only)
  perform realtime.send(jsonb_build_object('type', 'round.read', 'round_id', p_round),
                        'round.read', 'circle:' || v_round.circle_id::text, true);

  -- Everyone has read: reveal now instead of waiting (state machine).
  select count(*) into v_reads from game.reads where round_id = p_round;
  select count(*) into v_readers from circles.members m
   where m.circle_id = v_round.circle_id and m.left_at is null and m.user_id <> v_round.speaker_id;
  if v_reads >= v_readers then
    perform game.reveal_rounds(array[p_round], now());
  end if;
end $$;

-- Called by the scheduler every minute.
create function game.reveal_due_rounds(p_now timestamptz default now(), p_limit integer default 5000)
returns integer language plpgsql security definer set search_path = ''
as $$
declare v_ids uuid[];
begin
  select coalesce(array_agg(id), '{}') into v_ids from (
    select r.id from game.rounds r
    where r.state in ('claimed', 'rest') and r.reveal_at <= p_now
    order by r.reveal_at
    limit p_limit
    for update skip locked) due;
  return game.reveal_rounds(v_ids, p_now);
end $$;

-- Read-only RPCs the app may call (schema api).
create function api.me()
returns table (user_id uuid, display_name text, avatar_key text, locale text, timezone text)
language sql stable security definer set search_path = ''
as $$
  select p.user_id, p.display_name, p.avatar_key, p.locale, p.timezone
  from identity.profiles p where p.user_id = (select auth.uid())
$$;

-- "4 of 6 have read": counts only, never who or what.
create function api.round_progress(p_round uuid)
returns table (reads_in integer, readers_total integer)
language sql stable security definer set search_path = ''
as $$
  select (select count(*)::integer from game.reads x where x.round_id = r.id),
         (select count(*)::integer - 1 from circles.members m
           where m.circle_id = r.circle_id and m.left_at is null)
  from game.rounds r
  where r.id = p_round and circles.is_member(r.circle_id)
$$;

-- Still to write during the build (same pattern):
--   identity.upsert_profile / record_consent / set_stat_preference / request_deletion / purge_user
--   circles.create_circle / create_invite / join_with_code / leave / set_schedule / set_away / block_user / file_report
--   game.react / answer_rest / open_due_rounds (pick Speaker + stat from seed) / rotate_speaker (backup, deletes stale seal)
--   game.rest_unclaimed_rounds (backup cutoff passed -> rest card)
--   league.apply_round_revealed / close_season / assign_titles
--   ops.begin_idempotent / finish_idempotent

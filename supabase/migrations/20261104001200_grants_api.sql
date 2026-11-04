-- BLAG migration 12: grants (least privilege) and the api read views
--   anon            nothing
--   authenticated   SELECT on chosen columns (RLS filters rows) + api RPCs
--   svc_<service>   EXECUTE on its own write functions only (no table grants)
--   service_role    not used by app code (CI and admin scripts only)
-- Only schema `api` is exposed through the Data API (supabase/config.toml).

revoke all on schema identity, circles, game, league, notify, ops, private, api from public;
revoke all on all tables    in schema identity, circles, game, league, notify, ops, private from public;
revoke all on all functions in schema identity, circles, game, league, notify, ops, private, api from public;

grant usage on schema identity, circles, game, league, notify, api to authenticated;

grant select (user_id, display_name, avatar_key) on identity.profiles to authenticated;
grant select on identity.consents, identity.stat_preferences to authenticated;
grant select (id, name, timezone, member_cap, archived_at, created_at) on circles.circles to authenticated;
grant select on circles.schedule_versions, circles.members, circles.away, circles.blocks to authenticated;
grant select (code, circle_id, max_uses, uses, expires_at, revoked_at) on circles.invites to authenticated;
grant select (id, circle_id, target_kind, reason, status, created_at, resolved_at) on circles.reports to authenticated;
grant select on game.stat_catalog, league.seasons to authenticated;
-- seed and speaker_attempt are never granted (a backup Speaker would reveal an absence).
grant select (id, circle_id, season_id, play_date, slot, card_type, rest_reason, state, stat_id,
              prompt_key, speaker_id, opens_at, speaker_cutoff_at, backup_cutoff_at, reveal_at,
              claim, claimed_at, revealed_value, truth_min, truth_max, is_truth, revealed_at)
  on game.rounds to authenticated;
grant select on game.reads, game.round_results, game.reactions, game.rest_answers to authenticated;
grant select on league.day_scores, league.standings, league.titles to authenticated;
grant select (id, user_id, platform, app_version, last_seen_at, revoked_at) on notify.devices to authenticated;
grant select on notify.preferences to authenticated;

grant execute on function circles.is_active_member(uuid, uuid), circles.is_member(uuid),
                          circles.shares_circle(uuid), circles.is_member_of_topic(text),
                          game.can_see_round(uuid, boolean), league.can_see_season(uuid),
                          ops.is_iana_timezone(text)
  to authenticated;
grant execute on function api.me(), api.round_progress(uuid) to authenticated;

grant usage on schema game to svc_game;
grant execute on function game.seal(uuid, uuid, integer, game.input_method),
                          game.claim(uuid, uuid, integer),
                          game.cast_read(uuid, uuid, game.verdict, integer)
  to svc_game;
grant usage on schema game to svc_scheduler;
grant execute on function game.reveal_due_rounds(timestamptz, integer) to svc_scheduler;
-- svc_identity, svc_circles, svc_league and svc_notify get grants with their functions.

-- Read views. security_invoker: the caller's own RLS and column grants apply.
create view api.stat_catalog with (security_invoker = true) as
  select stat_id, key, unit, min_value, max_value, floor_h, is_health
  from game.stat_catalog where active;

create view api.my_circles with (security_invoker = true) as
  select c.id as circle_id, c.name, c.member_cap, m.role, m.joined_at
  from circles.circles c
  join circles.members m on m.circle_id = c.id
  where m.user_id = (select auth.uid()) and m.left_at is null and c.archived_at is null;

create view api.circle_members with (security_invoker = true) as
  select m.circle_id, m.user_id, p.display_name, p.avatar_key, m.role, m.joined_at
  from circles.members m
  join identity.profiles p on p.user_id = m.user_id
  where m.left_at is null;

create view api.circle_schedule with (security_invoker = true) as
  select distinct on (s.circle_id)
         s.circle_id, s.effective_from, s.drop_time, s.rounds_per_day, s.reveal_time_1, s.reveal_time_2
  from circles.schedule_versions s
  where s.effective_from <= current_date
  order by s.circle_id, s.effective_from desc;

create view api.my_away with (security_invoker = true) as
  select a.circle_id, a.starts_on, a.ends_on from circles.away a
  where a.user_id = (select auth.uid());

-- Today's Speaker stays secret until they claim, except to themselves (D-15).
create view api.rounds with (security_invoker = true) as
  select r.id as round_id, r.circle_id, r.season_id, r.play_date, r.slot, r.card_type,
         r.state, r.stat_id, r.prompt_key,
         case when r.claimed_at is not null or r.speaker_id = (select auth.uid())
              then r.speaker_id end as speaker_id,
         r.speaker_id = (select auth.uid()) as i_am_speaker,
         r.opens_at, r.reveal_at, r.claim, r.revealed_value, r.truth_min, r.truth_max,
         r.is_truth, r.revealed_at
  from game.rounds r;

create view api.my_reads with (security_invoker = true) as
  select x.round_id, x.verdict, x.guess, x.updated_at
  from game.reads x where x.reader_id = (select auth.uid());

create view api.rest_answers with (security_invoker = true) as
  select a.round_id, a.user_id, p.display_name, a.choice
  from game.rest_answers a
  join identity.profiles p on p.user_id = a.user_id;

create view api.round_results with (security_invoker = true) as
  select rr.round_id, rr.user_id, p.display_name, rr.is_speaker, rr.correct,
         rr.closest, rr.in_zone, rr.misreads, rr.points
  from game.round_results rr
  join identity.profiles p on p.user_id = rr.user_id;

create view api.standings with (security_invoker = true) as
  select st.season_id, st.user_id, p.display_name, p.avatar_key,
         st.best20_points, st.days_played, st.rank
  from league.standings st
  join identity.profiles p on p.user_id = st.user_id;

-- Personal layer: only my own rows, as a story source, never a leaderboard (D-10).
create view api.my_month with (security_invoker = true) as
  select d.season_id, d.play_date, d.points, d.rounds_played
  from league.day_scores d where d.user_id = (select auth.uid());

grant select on all tables in schema api to authenticated;

-- BLAG migration 10: access helpers and Row Level Security
-- RLS is ON for every table. Clients only ever SELECT, and only their own
-- circles. Tables with no policy (private.seals, ops.*, notify.deliveries)
-- return no rows to any client.

-- Helpers run as owner and return only a yes/no.
create function circles.is_active_member(p_circle uuid, p_user uuid)
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (select 1 from circles.members m
                 where m.circle_id = p_circle and m.user_id = p_user and m.left_at is null)
$$;

create function circles.is_member(p_circle uuid)
returns boolean language sql stable security definer set search_path = ''
as $$ select circles.is_active_member(p_circle, (select auth.uid())) $$;

create function circles.shares_circle(p_other uuid)
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (select 1 from circles.members a
                 join circles.members b on b.circle_id = a.circle_id
                 where a.user_id = (select auth.uid()) and a.left_at is null
                   and b.user_id = p_other and b.left_at is null)
$$;

-- Realtime topics look like circle:<uuid>; anything else is refused.
create function circles.is_member_of_topic(p_topic text)
returns boolean language plpgsql stable security definer set search_path = ''
as $$
begin
  if p_topic !~ '^circle:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then
    return false;
  end if;
  return circles.is_member(substr(p_topic, 8)::uuid);
end $$;

create function game.can_see_round(p_round uuid, p_require_revealed boolean)
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (select 1 from game.rounds r
                 where r.id = p_round
                   and circles.is_member(r.circle_id)
                   and (not p_require_revealed or r.state = 'revealed'))
$$;

create function league.can_see_season(p_season uuid)
returns boolean language sql stable security definer set search_path = ''
as $$
  select exists (select 1 from league.seasons s
                 where s.id = p_season and circles.is_member(s.circle_id))
$$;

alter table game.stat_catalog         enable row level security;
alter table identity.profiles         enable row level security;
alter table identity.consents         enable row level security;
alter table identity.stat_preferences enable row level security;
alter table circles.circles           enable row level security;
alter table circles.schedule_versions enable row level security;
alter table circles.members           enable row level security;
alter table circles.away              enable row level security;
alter table circles.invites           enable row level security;
alter table circles.blocks            enable row level security;
alter table circles.reports           enable row level security;
alter table league.seasons            enable row level security;
alter table league.day_scores         enable row level security;
alter table league.standings          enable row level security;
alter table league.titles             enable row level security;
alter table game.rounds               enable row level security;
alter table game.reads                enable row level security;
alter table game.round_results        enable row level security;
alter table game.reactions            enable row level security;
alter table game.rest_answers         enable row level security;
alter table private.seals             enable row level security;
alter table notify.devices            enable row level security;
alter table notify.preferences        enable row level security;
alter table notify.deliveries         enable row level security;
alter table ops.idempotency_keys      enable row level security;
alter table ops.audit_log             enable row level security;
alter table ops.feature_flags         enable row level security;
alter table ops.blocked_terms         enable row level security;
alter table ops.deletion_requests     enable row level security;

create policy read_catalog on game.stat_catalog for select to authenticated using (active);

create policy read_self_or_circlemate on identity.profiles for select to authenticated
  using (user_id = (select auth.uid()) or circles.shares_circle(user_id));
create policy read_own on identity.consents         for select to authenticated using (user_id = (select auth.uid()));
create policy read_own on identity.stat_preferences for select to authenticated using (user_id = (select auth.uid()));

create policy read_member on circles.circles           for select to authenticated using (circles.is_member(id));
create policy read_member on circles.schedule_versions for select to authenticated using (circles.is_member(circle_id));
create policy read_member on circles.members           for select to authenticated using (circles.is_member(circle_id));
create policy read_own    on circles.away              for select to authenticated using (user_id = (select auth.uid()));
create policy read_member on circles.invites           for select to authenticated using (circles.is_member(circle_id));
create policy read_own    on circles.blocks            for select to authenticated using (blocker_id = (select auth.uid()));
create policy read_own    on circles.reports           for select to authenticated using (reporter_id = (select auth.uid()));

create policy read_member on league.seasons    for select to authenticated using (circles.is_member(circle_id));
create policy read_member on league.day_scores for select to authenticated using (league.can_see_season(season_id));
create policy read_member on league.standings  for select to authenticated using (league.can_see_season(season_id));
create policy read_member on league.titles     for select to authenticated using (league.can_see_season(season_id));

-- speaker_id is masked by api.rounds until the claim (D-15).
create policy read_member on game.rounds for select to authenticated using (circles.is_member(circle_id));

-- Own answer any time; everyone else's only after the reveal.
create policy read_own_or_revealed on game.reads for select to authenticated
  using (reader_id = (select auth.uid()) or game.can_see_round(round_id, true));
create policy read_own_or_revealed on game.rest_answers for select to authenticated
  using (user_id = (select auth.uid()) or game.can_see_round(round_id, true));
create policy read_revealed on game.round_results for select to authenticated
  using (game.can_see_round(round_id, true));
create policy read_revealed on game.reactions for select to authenticated
  using (game.can_see_round(round_id, true));

create policy read_own on notify.devices     for select to authenticated using (user_id = (select auth.uid()));
create policy read_own on notify.preferences for select to authenticated using (user_id = (select auth.uid()));

-- Realtime: members receive their circle's broadcasts; clients may not send.
create policy members_receive on realtime.messages for select to authenticated
  using (realtime.messages.extension = 'broadcast' and circles.is_member_of_topic(realtime.topic()));

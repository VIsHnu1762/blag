-- BLAG migration 04: circles, schedule, members, away status, invites, safety

create table circles.circles (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (char_length(btrim(name)) between 1 and 32),
  timezone    text not null check (ops.is_iana_timezone(timezone)),
  member_cap  smallint not null default 8 check (member_cap between 3 and 8),
  created_by  uuid references identity.profiles(user_id) on delete set null,
  archived_at timestamptz,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Drop time, rounds per day (1 or 2, D-29) and reveal times. A new row takes
-- effect from a future date, so a change never alters a day in progress.
-- Both rounds open at drop_time; each round's Speaker and backup cutoffs split
-- its window 5:5:3 (08:00 -> 13:00 -> 18:00 -> 21:00 with the defaults, F-02).
create table circles.schedule_versions (
  circle_id      uuid not null references circles.circles(id) on delete cascade,
  effective_from date not null,
  drop_time      time not null default '08:00',
  rounds_per_day smallint not null check (rounds_per_day in (1, 2)),
  reveal_time_1  time not null default '21:00',
  reveal_time_2  time,
  changed_by     uuid references identity.profiles(user_id) on delete set null,
  created_at     timestamptz not null default now(),
  primary key (circle_id, effective_from),
  check (reveal_time_1 - drop_time >= interval '4 hours'),
  check (
    (rounds_per_day = 1 and reveal_time_2 is null)
    or (rounds_per_day = 2 and reveal_time_2 is not null
        and reveal_time_2 - reveal_time_1 >= interval '3 hours')
  )
);

create table circles.members (
  circle_id uuid not null references circles.circles(id) on delete cascade,
  user_id   uuid not null references identity.profiles(user_id) on delete cascade,
  role      circles.member_role not null default 'member',
  joined_at timestamptz not null default now(),
  left_at   timestamptz,
  primary key (circle_id, user_id),
  check (left_at is null or left_at >= joined_at)
);
create unique index members_one_organiser on circles.members (circle_id)
  where role = 'organiser' and left_at is null;
create index members_active_by_user on circles.members (user_id) where left_at is null;

-- Away status (F-13): never shown to anyone but the member themselves.
create table circles.away (
  circle_id  uuid not null,
  user_id    uuid not null,
  starts_on  date not null,
  ends_on    date not null,
  created_at timestamptz not null default now(),
  primary key (circle_id, user_id, starts_on),
  foreign key (circle_id, user_id) references circles.members(circle_id, user_id) on delete cascade,
  check (ends_on >= starts_on and ends_on - starts_on <= 31)
);

-- Plain codes, readable only by members, short-lived and use-limited.
create table circles.invites (
  code       text primary key check (code ~ '^[0-9A-HJKMNP-TV-Z]{8}$'),   -- Crockford base32
  circle_id  uuid not null references circles.circles(id) on delete cascade,
  created_by uuid references identity.profiles(user_id) on delete set null,
  max_uses   smallint not null default 7 check (max_uses between 1 and 7),
  uses       smallint not null default 0,
  expires_at timestamptz not null default now() + interval '7 days',
  revoked_at timestamptz,
  created_at timestamptz not null default now(),
  check (uses between 0 and max_uses)
);
create index invites_by_circle on circles.invites (circle_id);

-- App Store 1.2 (D-42): block abusive users. A block stops future co-membership.
create table circles.blocks (
  blocker_id uuid not null references identity.profiles(user_id) on delete cascade,
  blocked_id uuid not null references identity.profiles(user_id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);

-- App Store 1.2 (D-42): report objectionable content, answered within 24 hours.
create table circles.reports (
  id               uuid primary key default gen_random_uuid(),
  reporter_id      uuid references identity.profiles(user_id) on delete set null,
  reported_user_id uuid references identity.profiles(user_id) on delete set null,
  circle_id        uuid references circles.circles(id) on delete set null,
  target_kind      text not null check (target_kind in ('display_name', 'circle_name', 'avatar', 'behaviour')),
  reason           circles.report_reason not null,
  note             text check (char_length(note) <= 280),
  status           circles.report_status not null default 'open',
  created_at       timestamptz not null default now(),
  resolved_at      timestamptz,
  check ((status = 'open') = (resolved_at is null))
);
create index reports_open on circles.reports (created_at) where status = 'open';

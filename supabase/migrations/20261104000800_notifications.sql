-- BLAG migration 08: notifications

create table notify.devices (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references identity.profiles(user_id) on delete cascade,
  push_token   text not null unique check (char_length(push_token) between 10 and 256),
  platform     notify.platform not null,
  app_version  text not null check (app_version ~ '^[0-9]+\.[0-9]+\.[0-9]+$'),
  last_seen_at timestamptz not null default now(),
  revoked_at   timestamptz
);
create index devices_active_by_user on notify.devices (user_id) where revoked_at is null;

create table notify.preferences (
  user_id      uuid primary key references identity.profiles(user_id) on delete cascade,
  push_enabled boolean not null default false,
  quiet_from   time not null default '22:30',
  quiet_to     time not null default '08:00',
  max_per_day  smallint not null default 3 check (max_per_day between 0 and 5),
  updated_at   timestamptz not null default now()
);

-- Delivery log, kept 30 days. dedupe_key stops a notification being sent twice.
create table notify.deliveries (
  id            bigint generated always as identity primary key,
  user_id       uuid not null references identity.profiles(user_id) on delete cascade,
  kind          text not null check (kind ~ '^N-[0-9]{1,2}$'),
  round_id      uuid references game.rounds(id) on delete set null,
  dedupe_key    text not null unique check (char_length(dedupe_key) <= 200),
  status        notify.delivery_status not null default 'queued',
  scheduled_for timestamptz not null,
  sent_at       timestamptz,
  error         text check (char_length(error) <= 500),
  created_at    timestamptz not null default now()
);
create index deliveries_by_user_day on notify.deliveries (user_id, created_at desc);

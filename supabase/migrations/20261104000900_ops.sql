-- BLAG migration 09: ops (scheduler + platform) and updated_at triggers

create table ops.idempotency_keys (
  user_id      uuid not null,
  key          uuid not null,
  action       text not null check (action ~ '^[a-z]+\.[a-z_]+$'),     -- e.g. game.cast_read
  request_hash text not null check (char_length(request_hash) = 64),  -- sha-256 hex
  status_code  smallint,
  response     jsonb,
  created_at   timestamptz not null default now(),
  expires_at   timestamptz not null default now() + interval '48 hours',
  primary key (user_id, key)
);
create index idempotency_expiry on ops.idempotency_keys (expires_at);

create table ops.audit_log (
  id         bigint generated always as identity primary key,
  actor_id   uuid,
  service    text not null check (service in
               ('identity', 'circles', 'game', 'league', 'notify', 'scheduler', 'admin')),
  action     text not null,
  subject_id uuid,
  at         timestamptz not null default now(),
  meta       jsonb not null default '{}' check (jsonb_typeof(meta) = 'object')  -- never stat values
);
create index audit_by_subject on ops.audit_log (subject_id, at desc);

create table ops.feature_flags (
  key         text primary key check (key ~ '^[a-z][a-z0-9_.]{2,60}$'),
  enabled     boolean not null default false,
  rollout_pct smallint not null default 0 check (rollout_pct between 0 and 100),
  updated_at  timestamptz not null default now()
);

-- App Store 1.2 filter (D-42) for the only free text: display and circle names.
create table ops.blocked_terms (
  term     text primary key check (term = lower(term) and char_length(term) between 2 and 40),
  added_at timestamptz not null default now()
);

-- No foreign key on purpose: the row must outlive the account it deletes.
create table ops.deletion_requests (
  user_id      uuid primary key,
  source       text not null check (source in ('app', 'web')),
  requested_at timestamptz not null default now(),
  purge_after  timestamptz not null,
  completed_at timestamptz,
  check (purge_after > requested_at)
);

create trigger touch before update on identity.profiles         for each row execute function ops.touch_updated_at();
create trigger touch before update on identity.stat_preferences for each row execute function ops.touch_updated_at();
create trigger touch before update on circles.circles           for each row execute function ops.touch_updated_at();
create trigger touch before update on game.reads                for each row execute function ops.touch_updated_at();
create trigger touch before update on game.rest_answers         for each row execute function ops.touch_updated_at();
create trigger touch before update on league.standings          for each row execute function ops.touch_updated_at();
create trigger touch before update on notify.preferences        for each row execute function ops.touch_updated_at();
create trigger touch before update on ops.feature_flags         for each row execute function ops.touch_updated_at();

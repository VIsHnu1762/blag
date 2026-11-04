-- BLAG migration 03: stat catalogue (shared reference data) and identity

-- Seeded from kb/data/stats.yaml by scripts/gen-stats-catalog.ts.
create table game.stat_catalog (
  stat_id    text primary key check (stat_id ~ '^(ST|LF|PR|FN)-[0-9]{2}$'),
  key        text not null unique check (key ~ '^[a-z][a-z0-9_]{2,40}$'),
  unit       game.stat_unit not null,
  min_value  integer not null check (min_value >= 0),
  max_value  integer not null,
  floor_h    integer not null check (floor_h >= 0),   -- honest-range floor, base units (D-28)
  is_health  boolean not null default false,          -- steps, sleep: health rules (D-39)
  active     boolean not null default true,
  check (max_value > min_value)
);

create table identity.profiles (
  user_id               uuid primary key references auth.users(id) on delete cascade,
  display_name          text not null check (char_length(btrim(display_name)) between 1 and 24),
  avatar_key            text not null default 'default' check (avatar_key ~ '^[a-z0-9-]{1,32}$'),
  locale                text not null default 'en-IN' check (locale ~ '^[a-z]{2}(-[A-Z]{2})?$'),
  timezone              text not null default 'Asia/Kolkata' check (ops.is_iana_timezone(timezone)),
  age_attested_at       timestamptz not null,   -- 18+ confirmed (D-27); date of birth NOT stored
  age_gate_version      text not null check (age_gate_version ~ '^v[0-9]+$'),
  deletion_requested_at timestamptz,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now()
);

-- Append-only consent ledger: proof of what was agreed, when, to which notice.
create table identity.consents (
  id             bigint generated always as identity primary key,
  user_id        uuid not null references identity.profiles(user_id) on delete cascade,
  purpose        identity.consent_purpose not null,
  stat_id        text references game.stat_catalog(stat_id),
  granted        boolean not null,
  notice_version text not null check (notice_version ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'),
  recorded_at    timestamptz not null default now(),
  check ((purpose in ('stat_category', 'health_stats')) = (stat_id is not null))
);
create index consents_latest on identity.consents (user_id, purpose, stat_id, recorded_at desc);

-- Which stats a person is willing to be asked about (their focus lane).
create table identity.stat_preferences (
  user_id      uuid not null references identity.profiles(user_id) on delete cascade,
  stat_id      text not null references game.stat_catalog(stat_id),
  enabled      boolean not null default false,
  input_method game.input_method not null default 'manual',
  updated_at   timestamptz not null default now(),
  primary key (user_id, stat_id)
);

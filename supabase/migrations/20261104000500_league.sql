-- BLAG migration 05: league (seasons first, because rounds hang off a season)

create table league.seasons (
  id         uuid primary key default gen_random_uuid(),
  circle_id  uuid not null references circles.circles(id) on delete cascade,
  starts_on  date not null,
  ends_on    date not null,
  status     league.season_status not null default 'upcoming',
  finale_at  timestamptz,
  created_at timestamptz not null default now(),
  check (ends_on > starts_on),
  exclude using gist (circle_id with =, daterange(starts_on, ends_on, '[]') with &&)
);
create unique index seasons_one_active on league.seasons (circle_id) where status = 'active';

create table league.day_scores (
  season_id     uuid not null references league.seasons(id) on delete cascade,
  user_id       uuid not null references identity.profiles(user_id) on delete cascade,
  play_date     date not null,
  points        smallint not null check (points between 0 and 8),   -- 2 rounds x max 4 (D-29)
  rounds_played smallint not null check (rounds_played between 1 and 2),
  primary key (season_id, user_id, play_date)
);

-- Season score = sum of the best 20 day scores (D-16).
create table league.standings (
  season_id     uuid not null references league.seasons(id) on delete cascade,
  user_id       uuid not null references identity.profiles(user_id) on delete cascade,
  best20_points integer not null default 0 check (best20_points >= 0),
  days_played   smallint not null default 0 check (days_played between 0 and 31),
  rank          smallint check (rank >= 1),
  updated_at    timestamptz not null default now(),
  primary key (season_id, user_id)
);
create index standings_rank on league.standings (season_id, rank);

create table league.titles (
  season_id  uuid not null references league.seasons(id) on delete cascade,
  user_id    uuid not null references identity.profiles(user_id) on delete cascade,
  title_key  text not null check (title_key ~ '^[a-z][a-z0-9_]{2,40}$'),
  reason_key text check (reason_key ~ '^[a-z][a-z0-9_]{2,40}$'),
  awarded_at timestamptz not null default now(),
  primary key (season_id, user_id)
);

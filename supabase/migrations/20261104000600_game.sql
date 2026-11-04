-- BLAG migration 06: rounds, reads, results, reactions, rest answers
-- A "drop" is all rounds of one circle on one day: (circle_id, play_date), slot 1 or 2.

create table game.rounds (
  id                uuid primary key default gen_random_uuid(),
  circle_id         uuid not null references circles.circles(id) on delete cascade,
  season_id         uuid not null references league.seasons(id) on delete cascade,
  play_date         date not null,
  slot              smallint not null check (slot in (1, 2)),
  card_type         game.card_type not null default 'stat',
  rest_reason       game.rest_reason,
  state             game.round_state not null default 'scheduled',
  stat_id           text references game.stat_catalog(stat_id),
  prompt_key        text not null check (prompt_key ~ '^[a-z][a-z0-9_.]{2,60}$'),
  speaker_id        uuid references identity.profiles(user_id) on delete set null,  -- secret until claim (D-15)
  speaker_attempt   smallint not null default 1 check (speaker_attempt in (1, 2)), -- 2 = backup Speaker
  seed              text not null check (char_length(seed) between 16 and 64),     -- deterministic picks
  opens_at          timestamptz not null,
  speaker_cutoff_at timestamptz not null,
  backup_cutoff_at  timestamptz not null,
  reveal_at         timestamptz not null,
  claim             integer check (claim >= 0),
  claimed_at        timestamptz,
  revealed_value    integer check (revealed_value >= 0),   -- copied from the seal at reveal
  truth_min         integer,
  truth_max         integer,
  is_truth          boolean,
  revealed_at       timestamptz,
  created_at        timestamptz not null default now(),
  unique (circle_id, play_date, slot),
  check (opens_at < speaker_cutoff_at and speaker_cutoff_at < backup_cutoff_at
         and backup_cutoff_at < reveal_at),
  check ((claim is null) = (claimed_at is null)),
  check ((card_type = 'rest') = (rest_reason is not null)),
  check (card_type = 'rest' or stat_id is not null),
  check (card_type = 'stat' or claim is null),
  check (state <> 'claimed' or claim is not null),
  check ((state = 'revealed') = (revealed_at is not null)),
  check (state <> 'revealed' or card_type = 'rest'
         or (claim is not null and revealed_value is not null and truth_min is not null
             and truth_max is not null and is_truth is not null)),
  check (truth_min is null or truth_min <= truth_max)
);
create index rounds_due     on game.rounds (reveal_at) where state in ('open', 'claimed', 'rest');
create index rounds_circle  on game.rounds (circle_id, play_date desc, slot);
create index rounds_speaker on game.rounds (speaker_id, play_date desc);
create index rounds_season  on game.rounds (season_id);

create table game.reads (
  round_id   uuid not null references game.rounds(id) on delete cascade,
  reader_id  uuid not null references identity.profiles(user_id) on delete cascade,
  verdict    game.verdict not null,
  guess      integer check (guess >= 0),        -- optional closest-number guess
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (round_id, reader_id)
);
create index reads_by_reader on game.reads (reader_id);

-- Written on every read ("score on write", D-22), hidden by RLS until the reveal.
create table game.round_results (
  round_id    uuid not null references game.rounds(id) on delete cascade,
  user_id     uuid not null references identity.profiles(user_id) on delete cascade,
  is_speaker  boolean not null,
  correct     boolean,
  closest     boolean,
  in_zone     boolean,
  misreads    smallint check (misreads >= 0),
  points      smallint not null check (points between 0 and 4),
  computed_at timestamptz not null default now(),
  primary key (round_id, user_id),
  check (is_speaker = (misreads is not null)),
  check (not is_speaker or points <= 3)
);
create index round_results_by_user on game.round_results (user_id);

-- Fixed emoji set only: no free text in the MVP keeps moderation small (D-42).
create table game.reactions (
  round_id   uuid not null references game.rounds(id) on delete cascade,
  user_id    uuid not null references identity.profiles(user_id) on delete cascade,
  emoji      text not null check (emoji in ('😂', '😳', '🔥', '🤥', '👏', '💀')),
  created_at timestamptz not null default now(),
  primary key (round_id, user_id, emoji)
);

-- Rest-card answers: option keys only, hidden until the reveal. No points.
create table game.rest_answers (
  round_id   uuid not null references game.rounds(id) on delete cascade,
  user_id    uuid not null references identity.profiles(user_id) on delete cascade,
  choice     text not null check (choice ~ '^[a-z0-9_]{1,32}$'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (round_id, user_id)
);

-- BLAG migration 07: the sealed number (ADR-003, sealing-and-fairness.md)
-- Written once (primary key = no re-seal), copied to game.rounds.revealed_value
-- at the reveal, then DELETED in the same transaction (data minimisation).
-- If a backup Speaker takes over, the first Speaker's seal is deleted.

create table private.seals (
  round_id     uuid primary key references game.rounds(id) on delete cascade,
  speaker_id   uuid not null references identity.profiles(user_id) on delete cascade,
  value        integer not null check (value >= 0),
  input_method game.input_method not null,
  sealed_at    timestamptz not null default now()
);

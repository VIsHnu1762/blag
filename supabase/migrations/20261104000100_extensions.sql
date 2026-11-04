-- BLAG migration 01: extensions, schemas, service roles, shared helpers
-- See kb/07-architecture/data-model.md and ADR-011 / ADR-012.
--
-- Conventions
--   * one Postgres schema per service; a service writes only its own schema
--   * uuid keys, timestamptz everywhere, text + CHECK (no varchar)
--   * stat values are INTEGERS in the stat's base unit (minutes, steps)
--   * the app never writes tables: it READS api.* views (RLS-filtered) and
--     WRITES through Edge Functions that call SECURITY DEFINER functions
--   * sealed numbers live in schema `private`, which no client role can touch

create extension if not exists btree_gist;   -- seasons may not overlap
create extension if not exists pgmq;         -- Supabase Queues (service events)
create extension if not exists pg_cron;      -- scheduler tick + purges
create extension if not exists pg_net;       -- cron -> Edge Function HTTP calls

create schema identity;   -- identity service: profile, age gate, consents
create schema circles;    -- circles service: circles, members, invites, schedule, safety
create schema game;       -- game service: stat catalogue, rounds, reads, results
create schema league;     -- league service: seasons, day scores, standings, titles
create schema notify;     -- notifications service: devices, preferences, deliveries
create schema ops;        -- scheduler + platform: idempotency, audit, flags, deletion
create schema private;    -- sealed numbers. Never exposed, never granted.
create schema api;        -- the ONLY schema exposed to the app (read-only)

-- One NOLOGIN role per service; each Edge Function connects as its own role.
-- LOGIN + password are set once per environment from the secret store,
-- never in a migration (see kb/07-architecture/adr/ADR-012-service-database-roles.md).
-- Roles are cluster-wide, so creation is idempotent (safe on `supabase db reset`).
do $$
declare r text;
begin
  foreach r in array array['svc_identity', 'svc_circles', 'svc_game',
                           'svc_league', 'svc_notify', 'svc_scheduler'] loop
    if not exists (select 1 from pg_roles where rolname = r) then
      execute format('create role %I nologin', r);
    end if;
  end loop;
end $$;

create function ops.is_iana_timezone(tz text)
returns boolean language sql stable
set search_path = ''
as $$ select exists (select 1 from pg_catalog.pg_timezone_names where name = tz) $$;

create function ops.touch_updated_at()
returns trigger language plpgsql
set search_path = ''
as $$ begin new.updated_at := now(); return new; end $$;

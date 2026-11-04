-- Minimal stand-ins for objects Supabase provides (auth, realtime, pgmq, cron,
-- pg_net, vault, roles). Used ONLY by scripts/db/test-local.sh to run the
-- migrations and pgTAP tests on a plain Postgres without Docker.
-- Never apply this to a real Supabase project.

do $$ begin
  if not exists (select 1 from pg_roles where rolname = 'anon') then create role anon nologin; end if;
  if not exists (select 1 from pg_roles where rolname = 'authenticated') then create role authenticated nologin; end if;
  if not exists (select 1 from pg_roles where rolname = 'service_role') then create role service_role nologin; end if;
end $$;

create schema auth;
create schema realtime;
create schema pgmq;
create schema cron;
create schema net;
create schema vault;
create schema extensions;
grant usage on schema auth, realtime, extensions to authenticated;

create table auth.users (id uuid primary key, email text);
-- Same lookup order as Supabase's auth.uid().
create function auth.uid() returns uuid language sql stable as $$
  select coalesce(nullif(current_setting('request.jwt.claim.sub', true), ''),
                  (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub'))::uuid
$$;
grant execute on function auth.uid() to authenticated;

create table realtime.messages (
  id bigserial primary key, topic text, extension text, event text, payload jsonb, private boolean);
alter table realtime.messages enable row level security;
grant select on realtime.messages to authenticated;
create function realtime.topic() returns text language sql stable
  as $$ select current_setting('realtime.topic', true) $$;
grant execute on function realtime.topic() to authenticated;
create function realtime.send(payload jsonb, event text, topic text, private boolean default true)
returns void language sql
as $$ insert into realtime.messages (topic, extension, event, payload, private)
      values (topic, 'broadcast', event, payload, private) $$;

create table pgmq.q (queue text, msg jsonb);
create function pgmq.create(queue_name text) returns void language sql as $$ select $$;
create function pgmq.send_batch(queue_name text, msgs jsonb[]) returns setof bigint language sql
as $$ insert into pgmq.q select queue_name, m from unnest(msgs) m; select 1::bigint $$;

create function cron.schedule(job_name text, schedule text, command text) returns bigint
  language sql as $$ select 1::bigint $$;
create view vault.decrypted_secrets as select 'stub'::text as name, 'stub'::text as decrypted_secret;

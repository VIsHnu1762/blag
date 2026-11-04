-- BLAG migration 13: event queues and scheduled jobs
-- One inbox + dead-letter queue per consuming service. Consumers retry a
-- message 5 times, then move it to the *_dlq (D-21, ADR-010).
--   round.revealed     game     -> league_inbox, notify_inbox
--   member.left        circles  -> game_inbox (re-pick the Speaker if needed)
--   user.deletion_due  identity -> circles_inbox, game_inbox
--   season.closed      league   -> notify_inbox

select pgmq.create('league_inbox');   select pgmq.create('league_dlq');
select pgmq.create('notify_inbox');   select pgmq.create('notify_dlq');
select pgmq.create('game_inbox');     select pgmq.create('game_dlq');
select pgmq.create('circles_inbox');  select pgmq.create('circles_dlq');

-- Project URL and the scheduler's secret come from Supabase Vault, never from code.
select cron.schedule('scheduler-tick', '* * * * *', $job$
  select net.http_post(
    url     := (select decrypted_secret from vault.decrypted_secrets where name = 'project_url')
               || '/functions/v1/scheduler/tick',
    headers := jsonb_build_object('Content-Type', 'application/json', 'Authorization',
               'Bearer ' || (select decrypted_secret from vault.decrypted_secrets where name = 'scheduler_secret')),
    body    := '{}'::jsonb,
    timeout_milliseconds := 5000)
$job$);
select cron.schedule('purge-idempotency', '17 * * * *',
  $job$ delete from ops.idempotency_keys where expires_at < now() $job$);
select cron.schedule('purge-deliveries', '23 3 * * *',
  $job$ delete from notify.deliveries where created_at < now() - interval '30 days' $job$);
select cron.schedule('purge-invites', '29 3 * * *',
  $job$ delete from circles.invites where expires_at < now() - interval '1 day' $job$);

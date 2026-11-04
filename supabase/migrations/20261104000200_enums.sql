-- BLAG migration 02: enums (closed sets that rarely change)

create type identity.consent_purpose as enum (
  'terms', 'privacy_notice', 'stat_category', 'health_stats', 'push', 'product_analytics');

create type circles.member_role   as enum ('organiser', 'member');
create type circles.report_reason as enum (
  'harassment', 'hate', 'sexual', 'self_harm', 'spam', 'impersonation', 'other');
create type circles.report_status as enum ('open', 'actioned', 'dismissed');

create type game.stat_unit    as enum ('minutes', 'count');
create type game.input_method as enum ('manual', 'device');
create type game.card_type    as enum ('stat', 'rest');
create type game.rest_reason  as enum ('rest_day', 'no_claim');
-- Lifecycle from kb/03-game-design/state-machine.md. REVEALED and CLOSED are one
-- step here because points are already computed on each read (D-22).
create type game.round_state  as enum (
  'scheduled', 'paused', 'open', 'claimed', 'rest', 'revealed');
create type game.verdict      as enum ('truth', 'bluff');

create type league.season_status as enum ('upcoming', 'active', 'finale', 'archived');

create type notify.platform        as enum ('ios', 'android');
create type notify.delivery_status as enum (
  'queued', 'sent', 'skipped_quiet_hours', 'skipped_daily_cap', 'failed');

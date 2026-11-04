---
id: arch.api
title: API and realtime
section: 07-architecture
status: draft
summary: "Every client action (Edge Function), scheduled job and realtime event, with inputs, checks and responses."
order: 2
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.data, arch.services, game.state, arch.fairness]
---

# API and realtime

> **In short:** about twelve actions and two scheduled jobs; every action is authenticated, checked against the state machine, and idempotent.

## Conventions

- Actions are grouped by **service** (identity, circles, game, league, scheduler, notifications, proofs): each service is one Edge Function and each action a route inside it, e.g. `game/claim` ([service map](services.md), ADR-010).

- Each action is a Supabase **Edge Function** called with the member's auth token.
- Body includes `idempotency_key` (a UUID made on the device). Repeat calls with the same key return the first response.
- Errors return `{ error: { code, message } }`. Codes: `not_member`, `wrong_state`, `not_speaker`, `invalid_value`, `circle_full`, `rate_limited`.
- All times in requests and responses are ISO 8601 UTC; the app converts to local time.

## Actions

| Action | Input | Checks | Effect |
|---|---|---|---|
| `circle-create` | name, home_tz, times | 18+ confirmed | Creates circle, owner membership, invite code |
| `circle-invite-reset` | circle_id | Caller is owner | New invite code; old one stops working |
| `circle-join` | invite_code | Code valid; circle < 8 active members | Membership row |
| `circle-leave` | circle_id | Member | Sets `left_at`; removes from today's Speaker pool |
| `consent-set` | stat_id, on/off, extra_confirm | Stat exists; spicy/health need `extra_confirm` | Upserts consent |
| `lane-set` | circle_id, lane | Member | Updates lane from tomorrow |
| `round-seal` | round_id, value, proof_path? | Caller is current Speaker; state OPEN; value in range | Upserts `private.seals` (unlocked) |
| `round-claim` | round_id, value | Seal exists; state OPEN | Locks seal; writes claim; state → CLAIMED; realtime `round.claimed`; push N-2 |
| `round-pass` | round_id | Caller is current Speaker; state OPEN | Picks backup privately; push N-5 to backup |
| `round-read` | round_id, read, guess? | Member, not Speaker; state CLAIMED | Upserts read; if last missing read → triggers reveal |
| `round-react` | round_id, emoji | Member; state REVEALED/CLOSED; emoji in list | Inserts reaction |
| `account-delete` | confirm | Authenticated | Runs the deletion procedure ([data model](data-model.md#deletion-behaviour)) |

Rate limit *(Proposal)*: 60 actions per minute per user; 10 joins per hour per user.

## Scheduled jobs (pg_cron → Edge Function)

| Job | Every | Does |
|---|---|---|
| `drops-tick` | 5 minutes | Creates tomorrow's drops; opens due drops; applies Speaker and backup cutoffs; reveals due rounds; scores revealed rounds |
| `season-tick` | 1 hour | Closes ended seasons; computes best-20 scores and titles; creates the next season |

Supabase supports calling Edge Functions on a schedule with `pg_cron` and
`pg_net` [S-43]. Schedules run in UTC, so jobs compare against stored UTC times.
Each job is idempotent: it only moves drops whose time has passed and whose
state hasn't changed.

## Realtime events

One **private channel per circle**: `circle:{circle_id}`. Access is limited to
members through row-level security policies on Realtime's messages table, with
the channel created as private [S-44] *(verify the feature's current status
before relying on it)*.

| Event | Payload | Sent when |
|---|---|---|
| `drop.opened` | drop_id, card_type | Drop opens (no Speaker id) |
| `round.claimed` | round_id | Claim made; clients then fetch the claim |
| `round.revealed` | round_id | Reveal done; clients fetch results |
| `league.updated` | season_id | Day scores written |
| `season.finale` | season_id | Titles written |
| `circle.changed` | circle_id | Membership or settings changed |

Payloads carry **ids only**. Clients fetch the data through row-level security,
so a leaked event can't reveal a seal, a read or who passed.

## Shared game engine

Edge Functions import the pure functions from `packages/game-engine`:

```ts
truthZone(seal: number, statId: StatId): { min: number; max: number }
isTruth(claim: number, seal: number, statId: StatId): boolean
scoreRound(input: { seal; claim; statId; reads: Read[] }): Record<UserId, number>
seasonScore(dayScores: number[]): number          // sum of best 20
assignTitles(stats: SeasonStats, seed: string): Record<UserId, TitleKey>
pickSpeaker(members: Member[], history: SpeakerHistory, seed: string): UserId | null
```

These signatures are a proposal; the rules they implement are in
[game design](../03-game-design/README.md).

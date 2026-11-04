---
id: arch.fairness
title: Sealing and fairness
section: 07-architecture
status: draft
summary: "How BLAG keeps the game fair with typed-in numbers: sealing, hidden reads, server-side scoring, proof screenshots and what can't be prevented."
order: 3
last_updated: 2026-11-04
audience: [developers, product, judges, agents]
related: [arch.data, arch.api, privacy.threats, game.rules]
---

# Sealing and fairness

> **In short:** the real number is locked on the server before the claim, reads stay hidden until the reveal, and only the server scores; what can't be stopped is someone lying in their own seal, which only spoils their own game.

## The fairness problem

On iPhone, the app can't read Screen Time numbers to share them (R-01), so
players type them in. Without care, a Speaker could change their "real"
number after seeing the reads, or a reader could peek at others' reads.

## The design

| Threat to fairness | Prevention |
|---|---|
| Speaker changes the truth after seeing reads | Seal is **locked** when the claim is made; stored in `private.seals`, which clients can't read or write directly |
| Reader sees the truth early | Seal is copied to `round_results` only at reveal; no API returns it before |
| Reader copies others' reads | Reads of others are readable only after `revealed_at` (row-level security) |
| Client sends fake points or forces a reveal | Points and state changes exist only in Edge Functions and scheduled jobs (ADR-003) |
| Network retries double-count | Idempotency keys on every action |
| Someone works out who passed | Secret Speaker; backups chosen privately; no counts in events or UI (D-15) |
| Speaker types a false seal | **Can't be prevented** for typed numbers. Mitigated by optional screenshot proof shown after reveal, trust badges, and the fact that it only spoils the Speaker's own round |
| Edited screenshot | Can't be fully prevented; no points depend on it (D-17) |

## Optional commitment receipt *(Proposal, Next)*

For extra transparency, at seal time the server can show the Speaker a short
receipt code made from a hash of (round id, value, random salt). At the reveal,
anyone can check the receipt matches the revealed value. This proves the
server didn't change the seal either. It's not needed for the MVP.

## Fairness across platforms

Android may later allow auto-read; iPhone won't. To keep things fair:
- Trust levels show as **badges only**, never points (D-17).
- Auto-read values can still be edited before sealing; an edited value shows the "typed" badge.

## Testing fairness

Automated tests must show that, as a normal member, it's impossible to:
1. read `private.seals`,
2. read another member's read before the reveal,
3. see `speaker_id` before the claim (unless you are the Speaker),
4. change a seal after the claim,
5. write to `round_results`, `day_scores` or `titles`.

See [quality](../11-quality/README.md).

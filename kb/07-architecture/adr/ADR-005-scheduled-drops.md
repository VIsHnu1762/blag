---
id: adr.005
title: "ADR-005: Drive drops with a scheduler job"
section: 07-architecture
status: proposal
summary: "ADR-005: Drive drops with a scheduler job. Status: Proposed."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.home]
---

# ADR-005: Drive drops with a scheduler job

> **In short:** A scheduler job runs **every minute** via `pg_cron` (changed from 5 minutes on 2026-11-04 to meet the 2-minute reveal objective, D-22) and advances any drop whose stored UTC time has passed.

**Status:** Proposed

## Context

Drops open, change Speaker, and reveal at circle-specific local times across many time zones.

## Decision

A scheduler job runs **every minute** via `pg_cron` (changed from 5 minutes on 2026-11-04 to meet the 2-minute reveal objective, D-22) and advances any drop whose stored UTC time has passed. A `season-tick` job runs hourly. Both are idempotent. Early reveal is triggered by the last read.

## Options considered

| Option | For | Against |
|---|---|---|
| **Periodic tick** | Simple; self-healing if a run is missed | Up to 5 minutes' delay |
| One scheduled job per drop | Exact timing | Thousands of jobs to manage |
| External cron service | Independent of the database | Another service |

## Consequences

Reveal is at most about a minute late, plus processing; see the [backend blueprint](../backend-blueprint.md#scheduler-timings). Times are stored in UTC and computed with the time-zone database, so daylight-saving changes are handled.

---
id: adr.004
title: "ADR-004: Manual entry first, behind a provider interface"
section: 07-architecture
status: agreed
summary: "ADR-004: Manual entry first, behind a provider interface. Status: Accepted."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.home]
---

# ADR-004: Manual entry first, behind a provider interface

> **In short:** All stat values come through a StatProvider interface: `ManualProvider` (MVP), later `AndroidUsageProvider` and `HealthProvider`.

**Status:** Accepted

## Context

iOS doesn't allow exporting Screen Time numbers (R-01). Android allows reading usage with special access but needs policy checks (Q-16). The MVP must work everywhere.

## Decision

All stat values come through a **StatProvider** interface: `ManualProvider` (MVP), later `AndroidUsageProvider` and `HealthProvider`. The game never depends on a provider being available. Each value carries a `trust_level` badge that never affects points (D-17).

## Options considered

| Option | For | Against |
|---|---|---|
| **Manual first, providers later** | Works on every phone; no permissions at launch | Relies on honesty (mitigated by sealing) |
| Auto-read first | Less typing | Impossible on iOS; delays launch |

## Consequences

The seal screen must make finding numbers easy (A-09). Native modules come only after the MVP.

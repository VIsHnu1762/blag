---
id: adr.003
title: "ADR-003: Server-authoritative game with sealed values"
section: 07-architecture
status: agreed
summary: "ADR-003: Server-authoritative game with sealed values. Status: Accepted."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.home]
---

# ADR-003: Server-authoritative game with sealed values

> **In short:** Every state change, truth check, score and reveal happens in Edge Functions or scheduled jobs.

**Status:** Accepted

## Context

Clients are untrusted. If phones computed truth, points or reveals, a modified client could cheat or read hidden values.

## Decision

Every state change, truth check, score and reveal happens in **Edge Functions or scheduled jobs**. Seals live in a **private schema** with no client access. Clients only send intents (seal, claim, read, react) with idempotency keys.

## Options considered

| Option | For | Against |
|---|---|---|
| **Server decides** | Fair; hidden values stay hidden; one place to test rules | Every action needs a round-trip |
| Client computes, server stores | Snappier | Trivially cheatable |

## Consequences

Slight latency on actions, acceptable for a turn-based daily game. The game engine must be a pure, well-tested package (P-17).

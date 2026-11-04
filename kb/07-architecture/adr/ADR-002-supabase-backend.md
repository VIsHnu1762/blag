---
id: adr.002
title: "ADR-002: Use Supabase as the backend"
section: 07-architecture
status: proposal
summary: "ADR-002: Use Supabase as the backend. Status: Proposed (confirm at kick-off)."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.home]
---

# ADR-002: Use Supabase as the backend

> **In short:** Use Supabase: Auth, Postgres with row-level security, Edge Functions for every game action, `pg_cron` + `pg_net` for scheduled jobs [S-43], Realtime private channels [S-44], and Storage for screenshot proofs..

**Status:** Proposed (confirm at kick-off)

## Context

The game needs auth, a relational database with strict access rules, server-side functions, scheduled jobs, realtime updates and file storage, with as few services as possible.

## Decision

Use **Supabase**: Auth, Postgres with row-level security, Edge Functions for every game action, `pg_cron` + `pg_net` for scheduled jobs [S-43], Realtime private channels [S-44], and Storage for screenshot proofs.

## Options considered

| Option | For | Against |
|---|---|---|
| **Supabase** | All needed parts in one managed service; SQL and row-level security suit hidden values; generous free tier | Vendor coupling; Edge Functions run on Deno |
| Firebase | Mature realtime and auth | Document model and security rules are harder for relational game data and hidden values |
| Custom Node server + Postgres | Full control | More to build, host and secure |

## Consequences

One platform to learn and operate. Access rules live next to the data. Region choice and data residency must be decided (see [tech stack](../../08-tech-stack/README.md)).

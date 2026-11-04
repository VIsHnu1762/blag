---
id: adr.012
title: "ADR-012: One database role per service; the app only reads"
section: 07-architecture
status: proposal
summary: "ADR-012: One database role per service; the app only reads. Status: Proposed (D-41)."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.data, arch.services, adr.003, adr.010, adr.011]
---

# ADR-012: One database role per service; the app only reads

> **In short:** The app reads through `api` views under RLS and never writes tables; each Edge Function connects as its own Postgres role that can only run its own service's functions.

**Status:** Proposed (D-41)

## Context

ADR-010 splits the backend into services that each own their tables. Without enforcement, any function holding the service-role key could write any table, and a bug in one service could corrupt another's data. Supabase Edge Functions may connect to Postgres directly with any Postgres client [S-85].

## Decision

- **App users** (`authenticated`) get `SELECT` on chosen columns only, filtered by RLS, and read through views in the `api` schema, the only schema exposed by the Data API.
- **Each service** has a `NOLOGIN` role in the migrations (`svc_identity`, `svc_circles`, `svc_game`, `svc_league`, `svc_notify`, `svc_scheduler`). Per environment, a one-off script reading the secret store gives each role `LOGIN` and a password; the function's database URL lives in its own secret.
- Service roles get **no table grants**, only `EXECUTE` on their own SECURITY DEFINER functions. The Edge Function verifies the caller's JWT and passes the user id as `p_actor`.
- The **service-role key** is not used by app code (CI and admin scripts only).

## Options considered

| Option | For | Against |
|---|---|---|
| **Role per service, functions only** | Ownership enforced by the database; least privilege; matches ADR-010 | Six roles and secrets to manage |
| App writes tables under RLS | Fewer moving parts | Game rules in policies; hard to keep the seal fair (ADR-003) |
| One shared service-role key | Simplest | Any bug can touch any table; bypasses RLS |

## Consequences

Edge Functions connect through the pooler with prepared statements disabled [S-85]. Every new write function needs an explicit `GRANT EXECUTE` to its service role, and a pgTAP test proves the other roles can't run it.

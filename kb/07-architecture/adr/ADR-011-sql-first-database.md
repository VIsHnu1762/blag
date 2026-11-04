---
id: adr.011
title: "ADR-011: Plain SQL migrations instead of Prisma"
section: 07-architecture
status: proposal
summary: "ADR-011: Plain SQL migrations instead of Prisma. Status: Proposed (D-40)."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.data, adr.002, adr.012]
---

# ADR-011: Plain SQL migrations instead of Prisma

> **In short:** Write the database as plain SQL migration files and generate TypeScript types from it; no ORM for the MVP.

**Status:** Proposed (D-40)

## Context

The founder asked whether Prisma would make the PostgreSQL work easier. Most of BLAG's safety lives inside the database: row-level security, sealed values in a private schema, SECURITY DEFINER write functions, per-service roles, queues and cron jobs. An ORM maps tables to code; it does not help write those.

- Prisma connects with the service role or database URL in most setups, which bypasses Supabase RLS [S-83].
- Prisma Next added Supabase support and RLS policy authoring only in July 2026 [S-82]; too new to build a learner's production base on.
- Our server code runs in Deno Edge Functions and mostly calls one SQL function per use case (D-22), so a query builder adds little.
- Drizzle can define RLS policies and Supabase roles in TypeScript [S-84] and is the fallback if a TypeScript schema is ever wanted.

## Decision

The schema is written as **plain SQL** in `supabase/migrations` (one change per file, never edited after it is applied). TypeScript types are generated with `supabase gen types` into `packages/db-types`. Access rules and game functions are tested with **pgTAP** (`supabase test db`).

## Options considered

| Option | For | Against |
|---|---|---|
| **Plain SQL migrations** | Full Postgres: RLS, functions, roles, queues, cron; teaches Postgres directly; Supabase's default | More SQL to write by hand |
| Prisma (classic) | Familiar schema file, typed client | Bypasses RLS with privileged connections [S-83]; doesn't model functions, roles or queues |
| Prisma Next | RLS authoring, Supabase extension [S-82] | Brand new; still an ORM layer we barely use |
| Drizzle | TypeScript schema with RLS policies [S-84] | Second source of truth next to the SQL functions |

## Consequences

The SQL game rules must match `@blag/game-engine`; one shared set of test cases runs against both (D-44). Revisit if the app ever needs complex ad-hoc queries from a Node server.

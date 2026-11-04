---
id: adr.010
title: "ADR-010: Domain services as grouped Edge Functions, connected by events"
section: 07-architecture
status: proposal
summary: "ADR-010: Domain services as grouped Edge Functions, connected by events. Status: Proposed."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.repo, arch.services]
---

# ADR-010: Domain services as grouped Edge Functions, connected by events

> **In short:** Split the backend into seven services (identity, circles, game, league, scheduler, notifications, proofs).

**Status:** Proposed

## Context

The founder wants services that can be classified and optimised separately. Full microservices would add deployments, network failure points and data spread before the product is proven. Supabase recommends a few larger functions to reduce cold starts and a `_shared` folder for common code [S-69].

## Decision

Split the backend into **seven services** (identity, circles, game, league, scheduler, notifications, proofs). Each is **one Edge Function** with a route per action, **owns its tables** (only it writes them), and talks to other services through **events** written to an outbox and delivered via **Supabase Queues** [S-71]. Any service can later be extracted into its own microservice using the same contracts.

## Options considered

| Option | For | Against |
|---|---|---|
| **Domain services in one Supabase project** | Clear boundaries; cheap; one person can run it; extractable | Shared database needs ownership discipline |
| One function per action | Very granular | More cold starts; more to deploy [S-69] |
| Full microservices now | Independent scaling | Heavy operations for a solo builder; premature |
| One monolithic function | Simple | No classification or separate optimisation |

## Consequences

Event handlers must be idempotent. Extraction triggers and steps are in the [service map](../services.md#when-to-extract-a-service-into-its-own-microservice).

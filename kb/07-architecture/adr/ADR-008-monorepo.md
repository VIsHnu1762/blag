---
id: adr.008
title: "ADR-008: Monorepo with pnpm workspaces and Turborepo"
section: 07-architecture
status: proposal
summary: "ADR-008: Monorepo with pnpm workspaces and Turborepo. Status: Proposed."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.repo, arch.services]
---

# ADR-008: Monorepo with pnpm workspaces and Turborepo

> **In short:** Use one repository with pnpm workspaces (`apps/*`, `packages/*`) and Turborepo for the task graph and build cache.

**Status:** Proposed

## Context

BLAG has an app, shared rules used by app and server, a Supabase backend, a small web page for account deletion, and a knowledge base. They change together and must stay in sync.

## Decision

Use **one repository** with **pnpm workspaces** (`apps/*`, `packages/*`) and **Turborepo** for the task graph and build cache. Start pnpm with hoisted installs for React Native compatibility and revisit isolated installs later. Expo supports monorepos with Bun, npm, pnpm or Yarn workspaces and configures its bundler automatically from SDK 52 [S-67].

## Options considered

| Option | For | Against |
|---|---|---|
| **pnpm workspaces + Turborepo** | Fast installs; strict dependencies; cached builds; widely used with Expo | Some React Native libraries dislike isolated installs [S-67] |
| npm or Yarn workspaces | Simplest | Slower; weaker dependency strictness |
| Bun workspaces | Very fast | Younger ecosystem for React Native tooling |
| Separate repositories | Clear separation | Shared rules drift; harder for one person |

## Consequences

One place for everything, including the KB. Root `package.json` holds only workspace scripts. See [repository structure](../repository-structure.md).

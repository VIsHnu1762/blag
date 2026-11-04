---
id: adr.009
title: "ADR-009: Feature modules with enforced import boundaries"
section: 07-architecture
status: proposal
summary: "ADR-009: Feature modules with enforced import boundaries. Status: Proposed."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.repo, arch.services]
---

# ADR-009: Feature modules with enforced import boundaries

> **In short:** Organise app code by feature (`src/features/<feature>/` with a public `index.ts`), keep routes thin in `src/app/`, put shared UI in `src/ui/` and infrastructure in `src/lib/`.

**Status:** Proposed

## Context

The app will grow from about 16 screens to many more, possibly with more developers and AI agents editing code. Without rules, features import each other's internals and become hard to change.

## Decision

Organise app code by **feature** (`src/features/<feature>/` with a public `index.ts`), keep **routes thin** in `src/app/`, put shared UI in `src/ui/` and infrastructure in `src/lib/`. Enforce the dependency rules with an import-boundary lint rule in CI. Expo Router treats every file in `src/app` as a route, so non-route code must live elsewhere [S-68].

## Options considered

| Option | For | Against |
|---|---|---|
| **Feature folders + boundaries** | Changes stay local; clear ownership; easy for agents | Some upfront discipline |
| Type folders (components/, hooks/, screens/) | Familiar | Features scatter across folders as the app grows |
| Atomic design only | Good for UI | Says nothing about product logic |

## Consequences

A where-does-it-go table in the [repository structure](../repository-structure.md#where-does-it-go) guides every addition.

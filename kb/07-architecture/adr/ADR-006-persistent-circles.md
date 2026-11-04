---
id: adr.006
title: "ADR-006: Persistent circles instead of temporary rooms"
section: 07-architecture
status: agreed
summary: "ADR-006: Persistent circles instead of temporary rooms. Status: Accepted."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.home]
---

# ADR-006: Persistent circles instead of temporary rooms

> **In short:** Model a long-lived circle with seasons, drops and rounds.

**Status:** Accepted

## Context

The original spec used rooms with join codes for one game session. The product is now a daily ritual with monthly seasons (D-03).

## Decision

Model a long-lived **circle** with seasons, drops and rounds. Invite codes are stored hashed and can be reset.

## Options considered

| Option | For | Against |
|---|---|---|
| **Persistent circle** | History, seasons, titles, yearbook | More data to manage and delete correctly |
| Temporary rooms | Simple | No reason to return; no season |

## Consequences

Retention and deletion rules matter more ([data inventory](../../10-privacy-security/data-inventory.md)).

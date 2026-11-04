---
id: arch.adr
title: Architecture decision records
section: 07-architecture
status: living
summary: "Index of BLAG's architecture decisions, each with context, options and consequences."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.home]
---

# Architecture decision records

> **In short:** one short file per important technical decision, so anyone can see what was chosen, what else was considered, and why.

| ADR | Decision | Status |
|---|---|---|
| [ADR-001](ADR-001-expo-react-native.md) | Use React Native with Expo | Proposed (from the team brief; confirm at kick-off) |
| [ADR-002](ADR-002-supabase-backend.md) | Use Supabase as the backend | Proposed (confirm at kick-off) |
| [ADR-003](ADR-003-server-authoritative.md) | Server-authoritative game with sealed values | Accepted |
| [ADR-004](ADR-004-stat-providers.md) | Manual entry first, behind a provider interface | Accepted |
| [ADR-005](ADR-005-scheduled-drops.md) | Drive drops with a scheduler job | Proposed |
| [ADR-006](ADR-006-persistent-circles.md) | Persistent circles instead of temporary rooms | Accepted |
| [ADR-007](ADR-007-authentication.md) | Sign-in method | Proposed (Q-13 open) |

## Writing a new ADR

1. Copy an existing ADR and use the next number (for example `ADR-0nn-short-name.md`).
2. Fill in context, decision, options considered and consequences.
3. Start as **Proposed**. The team marks it **Accepted**, or **Superseded by ADR-nnn** later.
4. Run `python scripts/kb.py build && python scripts/kb.py check`.

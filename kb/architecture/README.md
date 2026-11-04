# Architecture

Status: **Seeded**. Last updated: 2026-11-04.

## What we already know

Requirements that come straight from the idea section:

| Requirement | Source |
|---|---|
| **Server-authoritative game**: phases, deadlines, valid actions, reveal and scoring all happen on the server | P-17 |
| **Sealed values**: a Speaker's real number is stored before the claim and is unreadable by others until the reveal | P-14 |
| **Persistent circles and seasons**, not throwaway rooms | D-03 |
| **Asynchronous daily drops** with a 24-hour window, plus an optional live mode | D-11, P-11 |
| **Time-zone-aware** "today" per circle | D-11 |
| **Data minimisation**: store only the value for the round's stat; no raw usage history | Principles |
| **Full deletion** of a player's data on request | P-26 |
| **Platform-neutral data layer**: one interface for manual, Android and (if ever possible) iOS data | P-45 to P-48 |

The earlier master prompt and readiness checklist (uploaded 2026-11-01) already
describe a proposed layout: game engine separate from the UI, a
`UsageDataProvider` interface with manual, mock and native implementations,
Edge Functions for each game action, and row-level security for hidden values.

## To do in this section

- [ ] Update the data model from "rooms" to **circles, seasons, daily drops and rounds**
- [ ] Game state machine for a daily drop, including late joins and passes
- [ ] System context and component diagrams (Mermaid)
- [ ] Sealing design: how a value is locked and later revealed, and who can read it when
- [ ] API and realtime event contracts
- [ ] Threat model: fake stats, early reads, duplicate votes, circle-code guessing
- [ ] Privacy architecture: what is stored, where, for how long
- [ ] Architecture decision records (ADRs)

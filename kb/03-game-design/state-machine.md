---
id: game.state
title: State machine
section: 03-game-design
status: proposal
summary: "Every state a drop can be in, the events that move it, who may act in each state, and what the server must reject."
order: 6
last_updated: 2026-11-04
audience: [developers, agents]
related: [game.rules, arch.api, arch.fairness]
---

# State machine

> **In short:** a drop moves SCHEDULED → OPEN → CLAIMED → REVEALED → CLOSED, with a backup-Speaker loop and a rest-round branch; only the server changes state.

## Drop states

```mermaid
stateDiagram-v2
    [*] --> SCHEDULED
    SCHEDULED --> OPEN: drop time reached (cron)
    SCHEDULED --> PAUSED: circle has fewer than 3 active members
    PAUSED --> SCHEDULED: circle back to 3+
    OPEN --> CLAIMED: Speaker seals and claims
    OPEN --> OPEN: Speaker passes or cutoff passes → backup Speaker chosen
    OPEN --> REST: backup cutoff passes with no claim
    CLAIMED --> REVEALED: reveal time reached OR all active readers have read
    REST --> REVEALED: reveal time reached
    REVEALED --> CLOSED: points written (immediately)
    CLOSED --> [*]
```

A rest day is scheduled directly as `REST` at the drop time.

In the database (`game.round_state`), REVEALED and CLOSED are one step, because points are already computed on every read (D-22). With two rounds a day, each round runs this machine on its own ([data model](../07-architecture/data-model.md#round-lifecycle-in-the-database)).

## Who can do what

| State | Speaker | Readers | Server |
|---|---|---|---|
| SCHEDULED | — | — | Open at drop time |
| OPEN | Seal (editable), claim, pass | See "secret Speaker" placeholder | Swap Speaker at cutoff |
| CLAIMED | Nothing (seal locked) | Read, change read, guess | Reveal at time or when all have read |
| REST | Answer prompt | Answer prompt | Reveal at time |
| REVEALED | React | React | Score, then close |
| CLOSED | React | React | — |
| PAUSED | — | — | Resume when 3+ members |

## Events and validation

The server rejects any action not allowed in the current state.

| Action | Valid when | Rejected if |
|---|---|---|
| `seal` | State OPEN, caller is current Speaker | Not Speaker; value outside the stat's allowed range; state not OPEN |
| `claim` | State OPEN, caller is current Speaker, seal exists | No seal yet; already claimed |
| `pass` | State OPEN, caller is current Speaker | Already claimed |
| `read` | State CLAIMED, caller is an active member, not the Speaker | Caller is Speaker; state not CLAIMED |
| `guess` | Same as read | Value outside allowed range |
| `react` | State REVEALED or CLOSED, caller is a member | Emoji not in preset list |

Every action carries a client-generated **idempotency key**, so retries after a
network failure don't double-submit ([API](../07-architecture/api-and-realtime.md)).

## Timers

| Timer | Default | Fires |
|---|---|---|
| Drop open | 08:00 | SCHEDULED → OPEN or REST |
| Speaker cutoff | 13:00 | Choose backup Speaker |
| Backup cutoff | 18:00 | OPEN → REST |
| Reveal | 21:00 | CLAIMED/REST → REVEALED |

A scheduler job runs every minute and advances any drop whose time has
passed ([ADR-005](../07-architecture/adr/ADR-005-scheduled-drops.md)). Early
reveal is triggered by the `read` action when it's the last missing read.

## Season states

```mermaid
stateDiagram-v2
    [*] --> ACTIVE: first day of month (or circle created)
    ACTIVE --> FINALE: last drop of the month closed
    FINALE --> ARCHIVED: titles and recap written
    ARCHIVED --> [*]
```

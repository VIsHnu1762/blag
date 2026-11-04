---
id: game.stats
title: Stats and the truth zone
section: 03-game-design
status: proposal
summary: "What stats can be claimed about, their sensitivity levels and consent rules, and how the truth zone decides whether a claim is true."
order: 4
last_updated: 2026-11-04
audience: [product, developers, design]
related: [registers.stats, game.scoring, mobile.home, privacy.home]
---

# Stats and the truth zone

> **In short:** stats come from a fixed catalogue with three sensitivity levels; a claim is true if it's within 10% of the sealed number (with a minimum per stat).

The full list is the [stat catalogue](../registers/stats.md) (edit
`kb/data/stats.yaml`).

## Families

| Prefix | Family | Examples |
|---|---|---|
| `ST` | Screen | Screen time, social apps, pickups, late-night use |
| `LF` | Life and health | Steps, sleep, workouts |
| `PR` | Productivity | Focus time, tasks finished, pages read |
| `FN` | Fun | Cups of tea or coffee, photos taken |

## Sensitivity levels

| Level | Examples | Consent | Extra rules |
|---|---|---|---|
| `standard` | Screen time, focus time | Turn on per stat | — |
| `spicy` | Pickups, late-night use | Turn on, then confirm a second time | Only offered if the member opted in to spicy stats |
| `health` | Steps, sleep, workouts | Turn on, then confirm a second time | Never ranked; may be health data under law (Q-04) |

## Focus lanes

| Lane | Typical stats |
|---|---|
| Fitness | Steps, workouts |
| Less social media | Social apps, video apps, pickups, notifications |
| Sleep | Late-night use, first pickup, sleep |
| Productivity | Focus time, tasks, pages read |
| Just for fun | Screen time, tea or coffee, photos |

When a member is Speaker, the [prompt engine](prompt-engine.md) prefers stats
from their lane that they've turned on.

## The truth zone

A claim is **true** if it's within the truth zone around the sealed value.

```text
half-width h = max( ceil(10% of seal), floor for this stat )
true if  seal − h ≤ claim ≤ seal + h
```

| Stat | Seal | 10% | Floor | Zone |
|---|---|---|---|---|
| Screen time (min) | 300 | 30 | 10 | 270–330 |
| Steps | 8,000 | 800 | 200 | 7,200–8,800 |
| Steps | 1,000 | 100 | 200 | 800–1,200 |
| Pickups | 12 | 2 | 3 | 9–15 |
| Late-night use (min) | 0 | 0 | 5 | 0–5 |
| Cups of tea | 2 | 1 | 0 | 1–3 |

Why a zone at all: people round numbers ("about 5 hours"). Without a zone, an
honest Speaker who says 300 for a sealed 297 would count as bluffing. The
Speaker sees the zone before claiming, so bluffing is always deliberate (P-51).

Open: 10% or 5% (Q-14). Test both in the hand-run.

## Where the numbers come from

| Source | Status | Trust badge |
|---|---|---|
| Typed in by the member | MVP, all platforms | Typed |
| Typed in with a screenshot | MVP | Screenshot |
| Read automatically on Android | Research (P-46) | Auto-read |
| Read from HealthKit / Health Connect | Research (P-48) | Auto-read |
| Read automatically on iPhone | Likely impossible (R-01) | — |

Badges never change points (D-17). See [mobile dependencies](../09-mobile-dependencies/README.md).

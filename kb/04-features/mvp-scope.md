---
id: features.mvp
title: MVP scope
section: 04-features
status: proposal
summary: "What's in and out of the first playable version of BLAG, the reasons, and the conditions for freezing the scope."
order: 1
last_updated: 2026-11-04
audience: [product, developers, judges]
related: [registers.features, roadmap.home, game.rules]
---

# MVP scope

> **In short:** one complete daily loop for real circles, with manual stats, comfort features, a monthly finale and full data deletion; nothing else.

## The MVP promise

> A circle of 3–8 friends can play one drop a day for a whole month, with
> numbers they type in, feel safe doing it, and enjoy a finale at the end.

## In

| Area | Features |
|---|---|
| Account | F-01 sign-up and 18+ gate · F-18 delete my data |
| Circles | F-02 create · F-03 join and leave |
| Comfort | F-04 consent and focus lane · F-09 reactions · F-13 invisible pass · F-14 catch-up card · F-15 rest day |
| Game | F-05 daily drop · F-06 seal and claim · F-07 read and guess · F-08 reveal · F-10 scoring and league · F-11 finale and titles |
| Memory | F-12 share card |
| Personal | F-16 my month (Could) |
| Platform | F-17 notifications |

## Out (and why)

| Not in MVP | Why |
|---|---|
| Automatic stats (F-23, P-46 to P-48) | iOS can't export them (R-01); Android needs policy checks (Q-16). Manual entry works everywhere |
| Contact sync (P-36) | Third-party data; invite links are enough (D-07) |
| Live mode (F-21) | Async daily play is the core; live is a later boost |
| Guess yourself, knowing scores, Group Wrapped (F-19, F-20, F-22) | Good retention features, but only after the core loop is proven |
| Other card types (P-38 to P-41) | One loop first (D-09) |
| Chat | Red line on round screens; the group chat already exists |
| Monetisation | Q-10 open; nothing that breaks the red lines |

## Size check

Rough screen count: about 16 screens ([screens](../06-design/screens.md)). Rough
backend surface: about 12 actions plus 2 scheduled jobs ([API](../07-architecture/api-and-realtime.md)).
That's realistic for a small student team over 8–10 weeks *(Assumption)*.

## Freezing the scope

Freeze the MVP when:
- [ ] The hand-run test is done and its results are in `kb/data/risks.yaml`
- [ ] Q-03, Q-13 and Q-14 are decided
- [ ] Every MVP feature has acceptance criteria the team agrees with

After freezing, any addition needs a decision entry and must replace something
of similar size.

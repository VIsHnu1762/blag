---
id: game.home
title: Game design
section: 03-game-design
status: proposal
summary: "Index of the exact game rules: a day's flow, scoring, seasons and titles, stats and the truth zone, prompts, state machine and edge cases."
last_updated: 2026-11-04
audience: [product, developers, agents]
related: [game.rules, game.scoring, idea.concept]
---

# Game design

> **In short:** the precise rules of BLAG, written so a developer can build them and a game master can run them by hand.

| Page | Answers |
|---|---|
| [Rules](rules.md) | How a drop works, step by step, with timings |
| [Scoring](scoring.md) | Exactly who gets how many points, with worked examples |
| [Seasons and titles](seasons-and-titles.md) | Season score, the league view, the finale and how titles are assigned |
| [Stats and the truth zone](stats-and-truth-zone.md) | What can be claimed, sensitivity levels, and when a claim counts as true |
| [Prompt engine](prompt-engine.md) | How the Speaker, topic and wording are chosen each day |
| [State machine](state-machine.md) | Every state a drop can be in, and the transitions |
| [Edge cases](edge-cases.md) | What happens when things don't go to plan |

Registers used here: [stat catalogue](../registers/stats.md) ·
[feature catalogue](../registers/features.md).

## Design rules for the game itself

1. **Score the reading, not the number** (D-05).
2. **Nobody loses points** for a wrong read (D-18).
3. **Absence is invisible and free** (D-08, D-15, D-16).
4. **Every number is sealed before the claim** (P-14).
5. **The server decides everything**: timing, truth, points (P-17).
6. **One round per drop** in the MVP (Q-11).

Values marked *(tunable)* are starting points to adjust after the
[hand-run test](../01-idea/07-validation-plan.md).

---
id: kb.home
title: BLAG knowledge base
section: kb
status: living
summary: Home of the BLAG knowledge base, a map of every section and where to start.
last_updated: 2026-11-04
audience: [everyone, agents]
related: [start.home, idea.vision, registers.index]
---

# BLAG knowledge base

> **In short:** everything about BLAG, researched and decided before development, in one place that both people and AI agents can read.

**BLAG: Are You Bluffing?** is a ten-minute daily game for close friend groups.
One friend makes a claim about their own habits, the others read it as TRUE
or BLUFF, and the real number is revealed. Points reward reading your friends,
never having "good" habits.

## Start in 60 seconds

1. Read the [vision](01-idea/01-vision.md) (3 minutes).
2. Read [how a day works](03-game-design/rules.md) (5 minutes).
3. Skim the [red lines](01-idea/05-principles-and-red-lines.md): the rules nothing may break.
4. Check the [open questions](registers/questions.md) to see what still needs deciding.

## Map

| # | Section | What you'll find | Status |
|---|---|---|---|
| 00 | [Start here](00-start-here/README.md) | Reading paths, [glossary](00-start-here/glossary.md), [FAQ](00-start-here/faq.md), [conventions](00-start-here/conventions.md) | Living |
| 01 | [Idea](01-idea/README.md) | Vision, problem, concept, 15 products studied, red lines, competitors, validation plan | Proposal |
| 02 | [Users](02-users/README.md) | Audience, personas, journeys, research plan | Draft |
| 03 | [Game design](03-game-design/README.md) | Rules, scoring, seasons and titles, stats, prompts, state machine, edge cases | Proposal |
| 04 | [Features](04-features/README.md) | MVP scope, user stories, notifications | Draft |
| 05 | [Brand](05-brand/README.md) | Personality, voice and tone, visual identity | Draft |
| 06 | [Design](06-design/README.md) | Emotional design, screens, flows, accessibility | Draft |
| 07 | [Architecture](07-architecture/README.md) | System overview, data model, API and realtime, fairness, ADRs | Draft |
| 08 | [Tech stack](08-tech-stack/README.md) | Chosen tools and alternatives | Proposal |
| 09 | [Mobile dependencies](09-mobile-dependencies/README.md) | What iOS and Android really allow; permissions | Research |
| 10 | [Privacy and security](10-privacy-security/README.md) | Data inventory, threat model, compliance map | Draft |
| 11 | [Quality](11-quality/README.md) | Test strategy, definition of done | Draft |
| 12 | [Roadmap](12-roadmap/README.md) | Phases from hand-run test to launch | Proposal |
| 13 | [Pitch](13-pitch/README.md) | Pitch lines, demo script, judge Q&A | Draft |
| — | [Registers](registers/README.md) | Ideas, features, stats, decisions, questions, risks, sources | Generated |

## For AI agents

Read [`AGENTS.md`](https://github.com/VIsHnu1762/blag/blob/main/AGENTS.md) first.
Machine-readable entry points: [`kb/export/kb-index.json`](export/kb-index.json),
the [single-file export](export/blag-kb.md), and the YAML registers in [`kb/data/`](data/).

## Readiness gate

Development starts only when all of these are true:

- [ ] Idea section reviewed; red lines agreed by the team
- [ ] Two-week hand-run test done and results recorded ([validation plan](01-idea/07-validation-plan.md))
- [ ] Game rules and scoring signed off ([game design](03-game-design/README.md))
- [ ] MVP scope frozen ([features](04-features/mvp-scope.md))
- [ ] Architecture ADRs accepted ([ADRs](07-architecture/adr/README.md))
- [ ] Questions Q-03 (age), Q-04 (health data), Q-13 (sign-in) and Q-14 (truth zone) decided
- [ ] Privacy review done ([privacy and security](10-privacy-security/README.md))

---
id: start.home
title: Start here
section: 00-start-here
status: living
summary: How to use the KB, with reading paths for each role and for AI agents.
last_updated: 2026-11-04
audience: [everyone, agents]
related: [kb.home, start.glossary, start.faq, start.conventions]
---

# Start here

> **In short:** pick your reading path below; every page opens with a one-line summary so you can skim.

## Reading paths

### "I've never heard of BLAG" (15 minutes)
1. [Vision](../01-idea/01-vision.md)
2. [Concept](../01-idea/03-concept.md)
3. [Game rules](../03-game-design/rules.md)
4. [FAQ](faq.md)

### Product and game design (1 hour)
1. [Problem and opportunity](../01-idea/02-problem-and-opportunity.md)
2. [Inspiration library](../01-idea/04-inspiration-library.md)
3. [Principles and red lines](../01-idea/05-principles-and-red-lines.md)
4. [Scoring](../03-game-design/scoring.md) and [seasons and titles](../03-game-design/seasons-and-titles.md)
5. [Users](../02-users/README.md)
6. [Open questions](../registers/questions.md)

### UI and brand
1. [Emotional design](../06-design/emotional-design.md)
2. [Voice and tone](../05-brand/voice-and-tone.md)
3. [Visual identity](../05-brand/visual-identity.md)
4. [Screens](../06-design/screens.md) and [flows](../06-design/flows.md)
5. [Accessibility](../06-design/accessibility.md)

### Engineering
1. [Game rules](../03-game-design/rules.md) and [state machine](../03-game-design/state-machine.md)
2. [Architecture overview](../07-architecture/README.md)
3. [Data model](../07-architecture/data-model.md) and [API and realtime](../07-architecture/api-and-realtime.md)
4. [Sealing and fairness](../07-architecture/sealing-and-fairness.md)
5. [Mobile dependencies](../09-mobile-dependencies/README.md)
6. [Quality](../11-quality/README.md)

### Hackathon judges and mentors (10 minutes)
1. [Pitch kit](../13-pitch/README.md)
2. [Vision](../01-idea/01-vision.md)
3. [Privacy and security](../10-privacy-security/README.md)

### AI agents
1. `AGENTS.md` at the repository root (rules and routing)
2. `llms.txt` (map) or `kb/export/blag-kb.md` (everything in one file)
3. `kb/data/*.yaml` for structured registers
4. [Conventions](conventions.md) for frontmatter and id formats

## How the KB is organised

- **Numbered sections** (00–13) go roughly in the order decisions depend on each other: idea → users → game → features → brand → design → architecture → stack → platforms → privacy → quality → roadmap → pitch.
- **Registers** are living lists with ids (P-, F-, D-, Q-, R-, A-, S-, ST-). They're kept as YAML in `kb/data/` and rendered into [registers](../registers/README.md).
- **Every page** has frontmatter (for tools and agents) and an *In short* line (for people).

## Glossary in one breath

A **circle** of friends plays one **drop** a day. The secret **Speaker**
**seals** their real number, then makes a **claim**. Everyone else **reads** it
as TRUE or BLUFF and may **guess** the number. At the **reveal**, points go to
good reads, close guesses and Speakers who fooled people. Daily points build a
**season** (one month) that ends in the **finale**. Full list: [glossary](glossary.md).

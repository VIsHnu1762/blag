# BLAG: Are You Bluffing?

> Your people. Their stats. Your call.

BLAG is a privacy-first social game for close friend groups of 3–8. Each day a
friend makes a claim about their own habits (screen time, steps, late-night
use) that might be a bluff. The circle reads it as **TRUE** or **BLUFF**, the
real number is revealed, and points reward reading your friends well, never
having "good" habits. Daily points build into a monthly season that ends in a
finale where every member is recognised.

**Status:** pre-development. This repository is the **knowledge base (KB)**:
everything researched, decided and planned before any app code is written.

## Read it your way

| You are… | Start here |
|---|---|
| New to BLAG | [Start here](kb/00-start-here/README.md), then [the vision](kb/01-idea/01-vision.md) |
| Designing | [Emotional design](kb/06-design/emotional-design.md) · [Screens](kb/06-design/screens.md) · [Brand](kb/05-brand/README.md) |
| Building | [Game rules](kb/03-game-design/rules.md) · [Architecture](kb/07-architecture/README.md) · [Features](kb/registers/features.md) |
| Pitching or judging | [Pitch kit](kb/13-pitch/README.md) |
| Looking for a decision | [Decision log](kb/registers/decisions.md) · [Open questions](kb/registers/questions.md) |
| An AI agent | [`AGENTS.md`](AGENTS.md) · [`llms.txt`](llms.txt) · [one-file export](kb/export/blag-kb.md) |

**Searchable website:** once GitHub Pages is switched on (see
[Contributing](CONTRIBUTING.md#publish-the-website)), the KB is browsable with search at
<https://vishnu1762.github.io/blag>.

## What's inside

| # | Section | Answers |
|---|---|---|
| 00 | [Start here](kb/00-start-here/README.md) | How to use the KB, glossary, FAQ, conventions |
| 01 | [Idea](kb/01-idea/README.md) | What BLAG is, why, and what we learned from 15 products |
| 02 | [Users](kb/02-users/README.md) | Who it's for: personas and journeys |
| 03 | [Game design](kb/03-game-design/README.md) | Exact rules, scoring, seasons, stats, prompts, state machine |
| 04 | [Features](kb/04-features/README.md) | MVP scope, user stories, notifications |
| 05 | [Brand](kb/05-brand/README.md) | Voice, tone, colours, type |
| 06 | [Design](kb/06-design/README.md) | Emotional design, screens, flows, accessibility |
| 07 | [Architecture](kb/07-architecture/README.md) | System, data model, API, fairness, ADRs |
| 08 | [Tech stack](kb/08-tech-stack/README.md) | Tools and why |
| 09 | [Mobile dependencies](kb/09-mobile-dependencies/README.md) | What iOS and Android allow |
| 10 | [Privacy and security](kb/10-privacy-security/README.md) | Data inventory, threats, compliance |
| 11 | [Quality](kb/11-quality/README.md) | Testing and definition of done |
| 12 | [Roadmap](kb/12-roadmap/README.md) | Phases and milestones |
| 13 | [Pitch](kb/13-pitch/README.md) | Pitch, demo script, judge Q&A |
| — | [Registers](kb/registers/README.md) | Ideas, features, stats, decisions, questions, risks, sources |

## Keeping it healthy

```bash
pip install pyyaml
python scripts/kb.py build   # regenerate registers, indexes and the one-file export
python scripts/kb.py check   # links, ids, metadata, stale files
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add or change anything.

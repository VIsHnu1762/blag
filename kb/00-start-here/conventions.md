---
id: start.conventions
title: Conventions
section: 00-start-here
status: agreed
summary: Frontmatter schema, id formats, status values and claim labels used across the KB.
order: 3
last_updated: 2026-11-04
audience: [everyone, agents]
related: [start.template, start.home]
---

# Conventions

> **In short:** every page has the same metadata block, every list item has a stable id, and every claim says how sure we are.

## Page frontmatter

Every Markdown page in `kb/` starts with this block (Decision D-14):

```yaml
---
id: game.scoring              # unique, dot-separated: <section>.<topic>
title: Scoring                # human title
section: 03-game-design       # folder name
status: proposal              # see below
summary: One sentence that says what the page answers.
last_updated: 2026-11-04
audience: [product, developers]   # optional: everyone, product, design, developers, judges, agents
related: [game.rules, game.seasons]   # optional: ids of neighbouring pages
---
```

| Status | Meaning |
|---|---|
| `seeded` | Scope and questions only |
| `draft` | Written, not yet reviewed |
| `proposal` | Reviewed enough to discuss; not agreed |
| `agreed` | The team signed it off |
| `research` | Findings that need re-checking over time |
| `living` | Expected to change constantly (indexes, how-tos) |
| `generated` | Built by `scripts/kb.py`; don't edit |

## Id series

| Series | What | Example | Lives in |
|---|---|---|---|
| `P-nn` | Idea | P-14 Seal before you claim | `kb/data/ideas.yaml` |
| `F-nn` | Feature | F-06 Seal and claim | `kb/data/features.yaml` |
| `D-nn` | Decision | D-05 Points from skill | `kb/data/decisions.yaml` |
| `Q-nn` | Open question | Q-03 Minimum age | `kb/data/questions.yaml` |
| `A-nn` | Assumption | A-01 Daily is wanted | `kb/data/risks.yaml` |
| `R-nn` | Risk | R-01 iOS data export | `kb/data/risks.yaml` |
| `S-nn` | Source | S-29 Apple forums | `kb/data/sources.yaml` |
| `ST-nn` `LF-nn` `PR-nn` `FN-nn` | Stat: screen, life, productivity, fun | ST-01 Screen time | `kb/data/stats.yaml` |
| `ADR-nnn` | Architecture decision record | ADR-003 | `kb/07-architecture/adr/` |

Ids are never reused. If something is dropped, keep it and change its status
(for ideas: `release: Cut`; for decisions: `status: Superseded`).

## Claim labels

| Label | Use when | Must include |
|---|---|---|
| **Fact** | Verified | A source id, e.g. [S-29] |
| **Estimate** | Third-party numbers | A source id, and treat as rough |
| **Assumption** | Believed, not tested | An `A-` id if it matters |
| **Decision** | Agreed by the team | A `D-` id |
| **Proposal** | Suggested | Nothing extra; that's the default |

## Writing

- One-sentence `> **In short:**` line under the title.
- Plain words, short sentences, international English.
- Tables for comparisons, numbered lists for steps, prose for reasoning.
- Dates as `YYYY-MM-DD`.
- Use [glossary](glossary.md) terms exactly.

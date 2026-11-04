# AGENTS.md: instructions for AI agents working on BLAG

You are working in the BLAG repository. BLAG is a privacy-first social game
for close friend groups (3–8 people). The project is **pre-development**: this
repository is a knowledge base (KB). People and agents read the **same files**;
there is no separate agent copy.

## 1. Load context efficiently

| Need | Read |
|---|---|
| Everything in one go | `kb/export/blag-kb.md` (generated, whole KB) |
| A map of all pages with one-line summaries | `llms.txt` or `kb/export/kb-index.json` |
| Exact vocabulary | `kb/data/glossary.yaml` |
| Structured lists | `kb/data/*.yaml` (ideas, features, stats, decisions, questions, risks, sources) |
| The rules every change must respect | `kb/01-idea/05-principles-and-red-lines.md` |
| Game rules and scoring | `kb/03-game-design/rules.md`, `kb/03-game-design/scoring.md` |

Every page starts with YAML frontmatter: `id`, `title`, `section`, `status`,
`summary`, `last_updated`, and optionally `audience` and `related` (page ids).
Follow `related` to find neighbouring pages.

## 2. Route the task

| Task | Primary pages | Data to update |
|---|---|---|
| Product or idea question | `kb/01-idea/` | `ideas.yaml` |
| Game rules, scoring, titles | `kb/03-game-design/` | `stats.yaml` |
| New or changed feature | `kb/04-features/`, `kb/registers/features.md` | `features.yaml` |
| UI copy or tone | `kb/05-brand/voice-and-tone.md` | — |
| Screens or flows | `kb/06-design/` | — |
| Database, API, backend | `kb/07-architecture/` | add an ADR in `kb/07-architecture/adr/` |
| Platform capability (iOS/Android) | `kb/09-mobile-dependencies/` | `sources.yaml`, `risks.yaml` |
| Privacy, security, legal | `kb/10-privacy-security/` | `risks.yaml`, `questions.yaml` |
| Planning | `kb/12-roadmap/` | — |
| Pitch or demo | `kb/13-pitch/` | — |

## 3. Non-negotiable rules

These come from the red lines. If a request conflicts with them, stop and say so.

1. **Never rank or score anyone by a stat value.** Points come only from reads, guesses and bluffing skill (D-05).
2. **Never make absence, passing or opting out visible** to other circle members (D-08, D-15).
3. **No streak counters, missed-day counts, paid restores, or loss/guilt notifications.**
4. **Never rank health stats** (steps, sleep, workouts). They need an extra opt-in.
5. **Never show raw history** to anyone but its owner. Others see only a round's revealed value.
6. **No free-text chat on round screens.** Reactions are preset emoji and are never counted.
7. **Sealed values are server-only until the reveal.** Clients never compute scores (P-14, P-17).
8. **Don't invent platform capabilities.** iOS does not let apps export Screen Time numbers (R-01). Check `kb/09-mobile-dependencies/` and cite sources.
9. **Use the glossary words.** Say "circle", "drop", "Speaker", "seal", "claim", "read", "reveal", "season". In UI copy never say "lie", "addicted", "lazy", "unhealthy".
10. **Launch audience is 18+** unless `Q-03` is decided otherwise.

## 4. How to change the KB

1. **Registers live in YAML.** To add an idea, decision, question, risk, source,
   feature, stat or glossary term, edit `kb/data/<name>.yaml`. Never edit
   `kb/registers/*.md`, `kb/00-start-here/glossary.md`, `kb/export/*` or `llms.txt`
   by hand: they're generated.
2. **Use the next free id** in the right series:

   | Series | Meaning | File |
   |---|---|---|
   | `P-nn` | Idea | ideas.yaml |
   | `F-nn` | Feature | features.yaml |
   | `D-nn` | Decision | decisions.yaml |
   | `Q-nn` | Open question | questions.yaml |
   | `A-nn` / `R-nn` | Assumption / risk | risks.yaml |
   | `S-nn` | Source | sources.yaml |
   | `ST-`/`LF-`/`PR-`/`FN-nn` | Stat (screen, life, productivity, fun) | stats.yaml |
   | `ADR-nnn` | Architecture decision | `kb/07-architecture/adr/ADR-nnn-*.md` |

3. **Pages need frontmatter.** Copy `kb/00-start-here/doc-template.md`. `status`
   is one of: `seeded`, `draft`, `proposal`, `agreed`, `research`, `living`,
   `generated`.
4. **Label claims**: *Fact* (with an `S-` source), *Estimate*, *Assumption*,
   *Decision* (with a `D-` id), *Proposal*.
5. **You can't decide for the team.** Record new conclusions as `Proposed` in
   `decisions.yaml` or as an `Open` question. Only people mark things `Agreed`.
6. **Paraphrase sources**, don't paste them. Add the URL and date to `sources.yaml`.
7. **Run the tool** before finishing:
   ```bash
   python scripts/kb.py build && python scripts/kb.py check
   ```
   The check must report 0 problems.
8. **Update `last_updated`** on every page you change.

## 5. When code arrives

The KB stays the source of truth for behaviour. If code and KB disagree, flag
it rather than silently changing either. Shared game logic must stay
independent of the UI and testable on its own (`kb/07-architecture/README.md`).

## 6. Writing style for human readers

Short sentences, plain words, international English. Lead with the answer.
Every page opens with a one-line **In short** summary for people skimming.

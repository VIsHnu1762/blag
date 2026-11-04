---
id: design.toolkit
title: Design toolkit
section: 06-design
status: agreed
order: 1.7
summary: "The five design references BLAG uses (Design with Intent, Perception-First Design, Impeccable, Taste Skill, React Bits), one job each, how each screen type maps to a design mode, the five-step process every screen goes through, and installs and licences."
last_updated: 2026-11-04
audience: [design, developers, agents]
related: [design.home, design.language, design.emotional, quality.home, design.accessibility]
---

# Design toolkit

> **In short:** five references the founder has used for a long time, each with one job so they never argue: Intent decides *why*, Perception-First Design checks *what people will perceive*, Impeccable builds and polishes the app, Taste Skill builds the web pages, React Bits only inspires motion (D-25).

## One job per tool

| Tool | Job in BLAG | When | Licence |
|---|---|---|---|
| **Design with Intent** [S-87] | UX strategy, journeys, structure, wireframes, accessibility, and the dark-pattern check | Before any screen, and as a check after | CC0 |
| **Perception-First Design** [S-89] | Diagnoses a screen through five layers: cognitive load, first impression, processing fluency, perception bias, decision architecture | The five key screens: first run, Today's Drop, seal and claim, read, reveal | CC BY-SA 4.0 (applying it is exempt) |
| **Impeccable** [S-86] | Main design system for the app: `PRODUCT.md`, `DESIGN.md`, iOS and Android rules, native audit, critique, later typeset, colour, motion and polish | Low-fidelity now; visuals after the core works | Apache 2.0 |
| **Taste Skill** [S-88] | Public web pages only (landing, invite): art direction, real browser checks at three widths | Near release | MIT |
| **React Bits** [S-90] | Motion ideas only; effects are rebuilt from scratch in Reanimated | After the core works | MIT + Commons Clause: no redistribution or ports |

Anthropic's frontend-design skill is not used separately: Impeccable builds on it.

## Design modes for BLAG's screens (D-24)

Impeccable names what success looks like on each surface. BLAG's rule: **native plumbing, expressive game moments.**

| Mode | BLAG surfaces | Rule |
|---|---|---|
| **Operate** (get a task done) | Sign-in, settings, invite, members, notifications | Feel native: platform controls, system font, back gesture, 44 pt (iOS) / 48 dp (Android) targets |
| **Experience** (you are inside the game) | Seal, claim, read, reveal, finale | BLAG's own look, motion and sound live here |
| **Read** | Privacy, help, my month | Calm and easy to read |
| **Persuade** | Landing page, store listing, invite web page | Taste Skill + Impeccable, aimed at the install |

## The five steps every screen goes through

1. **Why and where.** Intent `/journey` places the screen in the day or season loop. Perception-First Design runs its five-layer analysis (5 passes for a key screen, 1 for a small one). Output: requirements, not pixels.
2. **Layout.** Intent `/wireframe` writes the low-fidelity layout; Impeccable `shape` turns it into a UX plan.
3. **Build low-fidelity.** Greyscale React Native screen, system font, real words from the text catalogue (`src/i18n/en.ts`), proper layout (D-36).
4. **Check.** Impeccable `audit` (native) and `critique`, Intent `/evaluate` for dark patterns, Perception-First Design `evaluate`. Fix what they find; the [quality page](../11-quality/README.md) lists the bar.
5. **Later, once the core works.** Impeccable `typeset`, `colorize`, `animate`, `delight` and `polish`; motion inspired by React Bits and built with Reanimated; then `/impeccable document` writes `DESIGN.md` from what shipped.

## The ethics check agrees with our red lines

Intent's ethical-design guide independently says what BLAG's [principles](../01-idea/05-principles-and-red-lines.md) say:
breaking a streak must carry no penalty, and notifications should arrive because something real happened, never
at an algorithm-chosen "best moment". Every notification and every missed-day screen goes through Intent `/evaluate`.

## Installed in the repo

| Skill | Source | Where |
|---|---|---|
| `impeccable` (4.8) | `pbakaus/impeccable` | `.claude/skills/impeccable` |
| `intent`, `journey`, `organize`, `wireframe`, `evaluate`, `include`, `localize`, `specify` (1.7) | `ghaida/intent` | `.claude/skills/<name>` |
| `design-taste-frontend` | `Leonxlnx/taste-skill` | `.claude/skills/design-taste-frontend` |

Sources and content hashes are pinned in `skills-lock.json`; update with `npx skills update -p`.
`PRODUCT.md` at the repo root is the product record Impeccable reads (platform: `adaptive`).

**Perception-First Design is not committed**: copying its CC BY-SA text into this public repo would put that copy
under share-alike. Install it per person:

```text
/plugin marketplace add skovalik/perception-first-design
/plugin install perception-first-design@perception-first-design
```

**Impeccable's design-check hook** (`/impeccable hooks on`) is for the web pages only; its detector reads web code,
and native screens are audited from source by `audit` instead.

## Using the toolkit with an agent

| You want | Ask for |
|---|---|
| Plan a new screen | "Run Intent journey and wireframe for the reveal screen, then Impeccable shape" |
| Check a built screen | "Impeccable audit and critique the read screen; Intent evaluate it for dark patterns" |
| Check first impressions | "Perception-First Design evaluate the first-run flow" |
| Polish after the core works | "Impeccable typeset, then colorize, then animate the reveal" |
| Build the landing page | "Taste skill: build apps/web/index.html under 30 KB" |

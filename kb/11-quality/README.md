---
id: quality.home
title: Quality
section: 11-quality
status: draft
summary: "Test strategy for BLAG (game engine, access rules, flows, accessibility, devices), key test cases, and the definition of ready and done."
last_updated: 2026-11-04
audience: [developers, agents]
related: [game.scoring, arch.fairness, privacy.threats, registers.features]
---

# Quality

> **In short:** test the game rules as pure functions, prove hidden data stays hidden, run the main flows end to end on real phones, and never ship without the accessibility pass.

## Test layers

Tools decided in D-44. One shared file of test cases runs against both the TypeScript engine and the SQL rules, so they can never drift.

| Layer | What | Tool | Runs |
|---|---|---|---|
| Game engine unit tests | Truth zone, scoring, best-20, titles, Speaker choice | Vitest | Every push |
| Property tests | Scoring invariants (never negative, idempotent, unit-independent) | fast-check | Every push |
| Database and access rules | Every row in the [who-can-see table](../07-architecture/data-model.md#what-a-member-sees-rls); **49 checks exist** in `supabase/tests` | pgTAP via `supabase test db` (or `scripts/db/test-local.sh`) | Every push |
| Edge Function integration | State machine transitions and rejections | Deno test + local Supabase | Every push |
| Screens and hooks | Component states, copy keys, accessibility labels | Jest + React Native Testing Library | Every push |
| End-to-end flows | Join, Speaker turn, reader turn, pass, delete | Maestro on Android and iOS | Before each release |
| Design checks | Native audit, critique, dark-pattern check, five-layer review | Impeccable `audit` + `critique`, Intent `/evaluate`, Perception-First Design `evaluate` ([toolkit](../06-design/design-toolkit.md)) | Each screen, before it is called done |
| Accessibility | Labels, contrast, screen reader run-through | Lint + manual VoiceOver/TalkBack | Before each release |
| Device matrix | 2 iPhones, 3–5 Android brands including one mid-range | Manual | Before beta and release |
| KB health | Links, ids, metadata | `python scripts/kb.py check` | Every push |

## Must-have test cases

**Scoring** (from [scoring](../03-game-design/scoring.md)):
- Each worked example gives exactly the documented points.
- No input produces a negative score.
- Same inputs → same output.
- Speaker points never exceed 3; reader points never exceed 4.

**Fairness** (from [sealing and fairness](../07-architecture/sealing-and-fairness.md)):
- A member can't read `private.seals`.
- A member can't read another's read before `revealed_at`.
- `speaker_id` is hidden before the claim, except to the Speaker.
- A seal can't change after the claim.
- Clients can't write results, day scores or titles.

**State machine** (from [state machine](../03-game-design/state-machine.md)):
- Every action is rejected in every state where it isn't allowed.
- Cutoffs choose a backup; backup cutoff produces a rest round.
- Early reveal triggers on the last read.

**Comfort** (from the [red lines](../01-idea/05-principles-and-red-lines.md)):
- No screen, event or notification exposes a pass or absence.
- No notification contains a stat value.

**Edge cases:** one test per row in [edge cases](../03-game-design/edge-cases.md).

**Design** (from the [design toolkit](../06-design/design-toolkit.md)):
- Impeccable native audit scores at least 3 of 4 on accessibility and appearance.
- Intent `/evaluate` finds no dark pattern: no streak loss, no confirmshaming, no notification sent for engagement alone.
- Operate screens use platform controls; Experience screens respect Reduce Motion (D-24).

## Definition of ready (before building a feature)

- [ ] Has an `F-` id with acceptance criteria
- [ ] Checked against the red lines
- [ ] Screens and copy drafted
- [ ] Data and access rules identified

## Definition of done

- [ ] Acceptance criteria met and tested
- [ ] Unit and access-rule tests pass
- [ ] Copy passes the [voice checklist](../05-brand/voice-and-tone.md#checklist-for-any-new-copy)
- [ ] Accessibility checked (labels, contrast, reduced motion)
- [ ] Design checks passed for any new or changed screen (Impeccable audit, Intent evaluate)
- [ ] No stat values in logs or analytics
- [ ] KB updated (feature status, any new decisions) and `scripts/kb.py check` passes
- [ ] Reviewed by another team member, or by an agent review while the team is one person

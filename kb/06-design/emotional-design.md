---
id: design.emotional
title: Emotional design
section: 06-design
status: proposal
summary: "The feelings BLAG must create and avoid, the emotional arc of a day and a season, the design review of the early concept, and the fixes it led to."
order: 1
last_updated: 2026-11-04
audience: [design, product, everyone, judges]
related: [idea.principles, brand.voice, game.seasons, users.personas]
---

# Emotional design

> **In short:** BLAG should feel like mischief among friends (curiosity, suspense, delight, belonging) and never like being measured, exposed or left behind.

## Feelings to create and to avoid

| Create | Avoid |
|---|---|
| Curiosity ("who's the Speaker today?") | Obligation ("I have to keep my streak") |
| Mischief (planning a bluff) | Shame (about a number) |
| Suspense (waiting for the reveal) | Exposure (others seeing what you didn't share) |
| Delight (the stamp, being right) | Inferiority (being last because of habits) |
| Belonging (titles, shared jokes) | Guilt (missing days) |
| Being known (friends guess you well) | Being judged (labels like "Night Owl") |

## The emotional arc of a day

```text
 delight ┤                                   ★ reveal
         │                                  ╱ ╲
suspense ┤                     read ╭──────╯   ╲ reactions
         │                         ╱             ╲
curiosity┤  drop opens ───── claim╯               ╲__ calm
         └──────────────────────────────────────────────
           08:00          midday              21:00
```

Peaks are kept short: the app is mostly calm and the reveal is the one big moment.

## The emotional arc of a season

| Week | Feeling | Design support |
|---|---|---|
| 1 | Fresh start | Everyone at zero; new season card |
| 2 | Getting to know the rhythm | First titles hinted ("You're reading people well") |
| 3 | Rivalry, playful | League view; best moments so far |
| 4 | Anticipation | "Finale in 3 days" (no countdown pressure, just a heads-up) |
| Finale | Belonging, pride | Titles dealt one by one; moments; share card |

## Review of the early concept

The first specs ("Bluff the Stats", then the BLAG master prompt) were reviewed
for emotional design on 2026-11-01. The intent was strong, but the follow-through was weak:

| Issue found | Fix adopted |
|---|---|
| Emotional rules weren't carried into later documents (no voice guide, no emotional journey) | This page, [voice and tone](../05-brand/voice-and-tone.md), and the [red lines](../01-idea/05-principles-and-red-lines.md) |
| **Hot Seat** gave 20 seconds to "defend" a stat, which felt like a courtroom | Cut (P-13) |
| Titles like "Night Owl" and "The Lurker" labelled habits | Play-style titles only ([seasons and titles](../03-game-design/seasons-and-titles.md)) |
| "Rank the group by pickups" created a loser by design | Points from skill only (D-05) |
| Passing 3 stats triggered a visible Light-mode suggestion | Private comfort prompts; invisible pass (P-19) |
| Passing and skipping were visible to the group | Secret Speaker (D-15); away status hidden (D-08) |
| Manual entry undermined the reveal's tension | Seal before you claim (P-14), truth zone (P-51) |
| No design for losing | No negative points (D-18); every member gets a title (D-06); best 20 days (D-16) |
| No design for group dynamics (one person always targeted) | Speaker rotation by fewest turns; no "who in the circle" prompts that single anyone out negatively |
| British slang identity was accidental | Neutral, international copy (D-02) |

## Emotional design checklist for any new feature

- [ ] What should the person feel at each step? Write it down.
- [ ] Could the quietest member (see [personas](../02-users/personas.md)) feel exposed? How is that prevented?
- [ ] Could someone feel worse about their habits? Remove that path.
- [ ] Does losing still feel OK?
- [ ] Is absence invisible?
- [ ] Is there a moment of delight, and is it short?

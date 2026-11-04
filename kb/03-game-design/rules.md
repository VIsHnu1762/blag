---
id: game.rules
title: Rules
section: 03-game-design
status: proposal
summary: "Step-by-step rules of a daily drop: roles, timings, sealing, claiming, reading, reveal, passing and absence."
order: 1
last_updated: 2026-11-04
audience: [everyone, developers, agents]
related: [game.scoring, game.state, game.stats, game.edge]
---

# Rules

> **In short:** each day a secret Speaker seals their real number and makes a claim; everyone else reads it as TRUE or BLUFF and may guess the number; the reveal shows who was right.

## Roles

| Role | Who | Each day |
|---|---|---|
| **Speaker** | One member, chosen privately by the server | Seals the real number, then claims |
| **Reader** | Every other active member | Reads the claim (TRUE/BLUFF), optionally guesses |
| **Backup Speaker** | Chosen privately if the Speaker hasn't claimed by the cutoff | Same as Speaker |

The Speaker's identity is shown to the circle **only when they claim** (D-15).

## Requirements to play

- A circle needs **at least 3 members** to run drops. With fewer, drops pause.
- A member can be Speaker only for stats they have turned on (F-04).
- A member who joins during the day can read today's claim but isn't chosen as Speaker until tomorrow.

## Timeline of a drop

Times are in the circle's home time zone; each member sees them in their own
local time. All values *(tunable)* by the organiser within limits.

| Default time | Event |
|---|---|
| 08:00 | **Drop opens.** Server picks the Speaker and topic privately ([prompt engine](prompt-engine.md)) |
| 08:00–13:00 | Speaker can seal and claim |
| 13:00 | **Speaker cutoff.** If no claim, a backup Speaker is chosen privately |
| 13:00–18:00 | Backup Speaker can seal and claim |
| 18:00 | **Backup cutoff.** If still no claim, the drop becomes a rest round |
| After a claim | Readers can read and guess until the reveal |
| 21:00 | **Reveal**, or earlier as soon as every active reader has read |

Every Sunday is a **rest day** with a non-stat prompt *(tunable)*.

## Step by step

### 1. Seal (Speaker)
1. The Speaker sees the topic, e.g. *"Steps yesterday"*, with help text on where to find the number ([stat catalogue](../registers/stats.md)).
2. Optionally, they guess their own number first (Next release, P-06).
3. They enter the **real number**. Optionally they attach a screenshot as proof.
4. The server stores it as the **seal**. Before the claim, the Speaker can still correct a typo; after the claim it's locked.

### 2. Claim (Speaker)
1. The app shows the **truth zone**: "Anything from 7,200 to 8,800 counts as the truth" ([truth zone](stats-and-truth-zone.md)).
2. The Speaker enters a **claim**. Inside the zone = truth; outside = bluff.
3. The claim is published to the circle with the Speaker's name.

### 3. Read (everyone else)
1. Each reader picks **TRUE** or **BLUFF**.
2. Optionally, they **guess** the real number.
3. They can change their read and guess until the reveal.
4. Nobody can see anyone else's read or guess before the reveal.

### 4. Reveal
1. At the reveal time (or once everyone has read), the server marks the round revealed.
2. Everyone sees: the sealed number, the **TRUTH** or **BLUFF!** stamp, each member's read and guess, and the points.
3. If the seal had a screenshot, it can now be viewed.
4. Members can add preset emoji reactions. No free text.

### 5. Points
Computed by the server using the [scoring rules](scoring.md), added to each
member's day score.

## Passing and absence

| Situation | Rule |
|---|---|
| Speaker taps **Pass** | A backup is chosen privately. Nobody learns who passed |
| Reader doesn't read | Gets 0 for the day. Nothing is shown to others |
| Member doesn't open the app | Nothing is shown. Their season counts their best 20 days anyway |
| Member wants a break | They can pause themselves; they won't be chosen as Speaker. Not shown to others |
| Member leaves the circle | Removed from future drops. Their past rounds remain, credited to "a former member" if they delete their account |

## Rest days

The drop shows a non-stat prompt from the [prompt bank](prompt-engine.md#rest-day-prompts).
Members answer by picking a circle member or an option. Results are revealed at
the reveal time. **Rest days give no points**: they're for fun.

## What the rules deliberately don't have

- No negative points for readers (D-18).
- No streaks or missed-day counts (D-08).
- No in-app disputes in the MVP. Sealing and optional proof make disputes rare (A-04).
- No chat on round screens (red lines).

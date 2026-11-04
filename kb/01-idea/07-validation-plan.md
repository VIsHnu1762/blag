---
id: idea.validation
title: Validation plan
section: 01-idea
status: proposal
summary: "How to test BLAG's riskiest assumptions cheaply before writing code, starting with a two-week hand-run test."
last_updated: 2026-11-04
audience: [product, everyone]
related: [registers.risks, roadmap.home, users.research]
---

# Validation plan

> **In short:** run BLAG by hand in WhatsApp for two weeks with three friend groups before building anything, and measure whether people come back.

The assumptions and risks themselves are listed in the
[risks and assumptions register](../registers/risks.md). This page is the plan
for testing them.

## Test 1: the two-week hand-run test (no code)

**Tests:** A-01 (daily is wanted), A-02 (bluffing is fun), A-04 (sealing feels
fair), A-05 (ten minutes), A-07 (focus lanes).

### Setup

1. Recruit **three friend groups** of 4–6 people: a hostel group, a class
   group and a long-distance group.
2. Each group gets a **WhatsApp group** and a **shared sheet**. One team member
   plays "the app" (the game master).
3. Everyone privately tells the game master which stats they're happy to use
   and picks a focus lane.

### Daily script for the game master

| Time | Action |
|---|---|
| 08:00 | Post: "Today's Speaker is a secret 👀" |
| 08:05 | DM the Speaker their topic and the truth-zone rule |
| Speaker replies | They DM their real number (the seal) and a screenshot if they like, then post their claim in the group |
| Until 21:00 | Members DM their read (TRUE/BLUFF) and a guess to the game master |
| 21:00 | Post the reveal: the real number, the stamp, who read it right, points |
| 21:05 | Update the sheet; post the league once a week |

Use the [scoring rules](../03-game-design/scoring.md) exactly. Make every Sunday
a rest day.

### What to record

| Measure | How |
|---|---|
| Daily participation | Count reads per day per group |
| Time spent | Ask 3 people per group to time themselves on days 3, 7 and 12 |
| Disputes | Note any argument about whether a claim was true |
| Passes and discomfort | Count passes; note anything awkward |
| Enjoyment | Day-14 interview, 10 minutes each |

### Day-14 interview questions

1. What was the best moment of the two weeks?
2. Was there a moment you felt uncomfortable? What happened?
3. Did you learn anything about a friend? About yourself?
4. Would you keep playing next month? Why or why not?
5. How did it feel to bluff? To be caught?
6. What would you change?

### Decide afterwards

| Result | Then |
|---|---|
| Most groups still playing on day 14 and say they'd continue | Proceed to the prototype |
| Engagement drops in week 2 | Revisit daily vs a few times a week; test twist cards |
| Frequent disputes about truth | Tighten sealing and proof before building |
| People feel exposed | Strengthen comfort features; review stat list |

Record results in `kb/data/risks.yaml` (assumption `status`) and any new
decisions in `kb/data/decisions.yaml`.

## Test 2: "find your number" task (30 minutes)

**Tests:** A-09. Ask 10 people with different phones to find yesterday's
screen time, pickups and steps. Time them and note where they get stuck. This
shapes the help text in [stat entry](../06-design/screens.md).

## Test 3: problem interviews

**Tests:** A-03. Talk to 10–15 people whose friend groups live apart. Plan in
[user research](../02-users/research-plan.md).

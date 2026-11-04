---
id: game.scoring
title: Scoring
section: 03-game-design
status: proposal
summary: "Exact point rules for readers and Speakers, with worked examples, ties and the reasoning behind each rule."
order: 2
last_updated: 2026-11-04
audience: [product, developers, agents]
related: [game.rules, game.seasons, game.stats]
---

# Scoring

> **In short:** readers get 2 points for a correct read and up to 2 more for a good guess; the Speaker gets 1 point for every reader they fooled, up to 3; nobody ever loses points.

## The rules

### Readers

| Event | Points | Why |
|---|---|---|
| Correct read (TRUE on a truth, BLUFF on a bluff) | **+2** | The core skill: reading your friend |
| Wrong read | **0** | Forgive by default; keeps quiet players playing (D-18) |
| Closest guess among readers who guessed | **+1** | Rewards knowing your friends' habits, not having habits |
| Guess inside the truth zone ("bullseye") | **+1** | Extra reward for a very good guess; stacks with closest |
| No read | **0** | Nothing shown to others |

A reader can earn at most **4 points** in a round.

### Speaker

| Event | Points | Why |
|---|---|---|
| Each reader who read wrong | **+1**, up to **+3** | The Speaker's aim is to be misread, whether they told the truth or bluffed |

The cap of 3 stops large circles giving Speakers far more points than small
ones. Because the Speaker wants to be misread either way, **telling the truth
convincingly-badly is as valid a strategy as bluffing**, which keeps rounds
unpredictable.

### Rest days and passes

Rest days score nothing. A Speaker who passes scores 0 that day; the backup
Speaker scores as Speaker.

## Worked examples

### Example 1: a bluff, five-member circle
Stat LF-01 *Steps yesterday*. Priya seals **8,000**. Truth zone is ±800
(10% of 8,000; the floor is 200), so **7,200–8,800** is true. She claims **9,400**: a bluff.

| Reader | Read | Guess | Correct read | Closest | Bullseye | Total |
|---|---|---|---|---|---|---|
| Arjun | BLUFF | 8,100 | +2 | +1 | +1 | **4** |
| Meera | TRUE | 9,300 | 0 | 0 | 0 | **0** |
| Kabir | BLUFF | — | +2 | — | — | **2** |
| Sana | TRUE | 9,000 | 0 | 0 | 0 | **0** |

Priya: 2 readers misread → **+2**.

### Example 2: a truth that looks like a bluff
Stat ST-07 *Late-night use*. Kabir seals **45** minutes. Zone ±5 (10% is 4.5,
rounded up to 5; floor is 5): **40–50**. He claims **45**: true.
All three readers read BLUFF. Readers: **0** each. Kabir: 3 misreads → **+3**.

### Example 3: tied guesses
Seal 120 minutes, zone 108–132. Two readers guess 110 and 130: both 10 away,
so both get **+1** closest, and both are inside the zone so both get **+1** bullseye.

### Example 4: a claim of zero
ST-07 seal **0**. Zone = floor = ±5 → **0–5** is true. A claim of 3 is the truth.

## Formal definition

```text
h          = max(ceil(0.10 × seal), floor(stat))          # truth-zone half-width
is_truth   = |claim − seal| ≤ h
correct(r) = (r.read = TRUE and is_truth) or (r.read = BLUFF and not is_truth)

reader_points(r) = 2·[correct(r)]
                 + 1·[r.guess ≠ null and |r.guess − seal| = min over readers with guesses of |g − seal|]
                 + 1·[r.guess ≠ null and |r.guess − seal| ≤ h]

speaker_points   = min(3, count of readers r with not correct(r))
```

Floors per stat are in the [stat catalogue](../registers/stats.md). For
time-of-day stats, values are minutes after midnight. The 10% figure is
*(tunable)* (Q-14).

## Properties the scoring must keep

These are test cases for the scoring engine ([quality](../11-quality/README.md)):

- No outcome produces negative points.
- A stat value never affects points except through the truth zone and guesses.
- Points are identical whether the round is played live or asynchronously.
- Re-running scoring on the same inputs gives the same result (idempotent).
- A reader who doesn't read scores exactly 0.
- Changing a stat's unit (minutes vs hours) doesn't change anyone's points.

## Changes from the original spec

The first brief had bets of 1–3 points and penalties for wrong reads. These
were dropped: bets added little skill and penalties punish the most hesitant
players (D-18). Bets could return as a *twist card* (P-07).

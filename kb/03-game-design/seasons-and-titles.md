---
id: game.seasons
title: Seasons and titles
section: 03-game-design
status: proposal
summary: "How day scores become a season score, what the league view shows, and how every member gets exactly one title at the finale."
order: 3
last_updated: 2026-11-04
audience: [product, developers, design]
related: [game.scoring, design.emotional, brand.voice]
---

# Seasons and titles

> **In short:** a season is a calendar month; your score is your best 20 days; at the finale every member gets exactly one play-style title.

## Seasons

- A season runs from the first to the last day of a **calendar month** in the circle's home time zone.
- A drop belongs to the season of its local date.
- Scores reset when a new season starts. Past seasons stay in the circle's history.
- A circle created mid-month starts a short first season. The "best 20 days" rule still applies, so a short season simply has fewer days to count.

## Season score

**Season score = the sum of a member's best 20 day scores** (D-16).

| Why 20 | |
|---|---|
| A month has 28–31 days, minus about 4 rest days | ~24–27 scoring days |
| Best 20 | Missing up to about a week costs nothing |
| Playing more | Never hurts: an extra day can only replace a lower one |

## League view

| Shows | Doesn't show |
|---|---|
| Members ordered by season score | Missed days, passes, streaks |
| Shared positions for ties ("joint 2nd") | Anyone's stat values |
| Each member's best moment so far (optional) | Gaps between scores as "behind by" |

The language is "the league", never "leaderboard" in the UI (see the [glossary](../00-start-here/glossary.md)).

## The finale

On the first day of a new season, the previous season's **finale** appears:

1. Final league positions.
2. **Titles**: every member who played at least one round gets exactly one.
3. **Moments**: best bluff, closest guess, most surprising reveal, described without numbers where possible.
4. A **share card** with titles and stamps, never stats (F-12).

## Titles

| Title | Given to | Minimum to qualify |
|---|---|---|
| **Poker Face** | Most readers fooled by bluffs | 2 bluffs as Speaker |
| **Open Book** | Highest share of truthful claims | 2 claims as Speaker |
| **Mind Reader** | Highest correct-read rate | 8 reads |
| **Bullseye** | Most bullseye guesses | 3 guesses |
| **Bluff Hunter** | Most correct BLUFF reads | 3 BLUFF reads |
| **True Believer** | Most correct TRUE reads | 3 TRUE reads |
| **Wildcard** | The boldest bluff that fooled at least half the readers | 1 such bluff |
| **Comeback** | Biggest rise in average day score from the first half to the second half of the season | Played in both halves |
| **Rookie** | First season in this circle | New this season |
| **Heart of the Circle** | Fallback, so everyone gets a title | Played at least one round |

### Assignment algorithm

1. Compute every member's eligibility and score for each title.
2. Go through titles **in the table order**. For each, give it to the best eligible member who has no title yet.
3. Ties: the member who reached the score first in the season wins; if still tied, a random choice seeded by the season id (so it's repeatable).
4. Members still without a title get **Heart of the Circle**. Several members can share it.

### Title rules

- Titles describe **how someone played**, never their habits. No titles from stat values ("Night Owl", "Couch Potato", "Step Master") (red lines).
- Every title's description is affectionate. Copy is in [voice and tone](../05-brand/voice-and-tone.md).

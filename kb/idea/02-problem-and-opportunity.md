# 02 · Problem and opportunity

Status: **Proposal**. Last updated: 2026-11-04. Sources are in the
[research log](research-log.md).

## Problem 1: We don't really know our own habits

- **Fact.** Self-reported screen time is unreliable. In one study of 202
  college students who shared their phone's screen-time screenshot, about 72%
  underestimated their daily use and about 28% overestimated it [S-17]. A
  study of Czech adolescents also found people usually underestimate both
  screen time and how often they check their phone [S-18].
- **Fact.** A University of Cape Town study of 267 people aged 18–25 found
  self-reports differed from tracked data in both directions depending on how
  it was measured, and suggested phone use distorts our sense of time [S-16].
- **Estimate.** Indians spent about five hours a day on their phones in 2024,
  with roughly 70% on social media, gaming and video, according to an EY
  report [S-19].

**What this means for BLAG:** the gap between what you *think* your number is
and what it actually is makes a natural game. It is also a real awareness
moment that doesn't need a lecture.

## Problem 2: Tools that tell us about our habits feel like judgement

- **Fact.** Screen-time apps such as Opal offer leaderboards against friends
  and a global community [S-21]. Some users have asked Opal for a way to turn
  off all social comparison because it doesn't feel good to rank above or
  below others [S-22].
- **Fact.** Research on leaderboards finds that ranking lifts top performers
  but can demotivate people near the bottom [S-26, S-27]. Smaller, tiered
  comparison groups are seen as fairer [S-28].
- **Fact.** Streak mechanics can create pressure. In a March 2026 survey of
  300 teenagers, most kept Snapchat streaks, a quarter had paid to restore
  one, and 42% would turn streaks off if they could [S-13].

**What this means for BLAG:** awareness has to arrive without ranking, guilt or
streak pressure. That is a design constraint, not a nice-to-have (see
[principles](06-principles-and-red-lines.md)).

## Problem 3: Friends drift apart without small daily moments

- **Assumption.** Friend groups who move to different cities, colleges or jobs
  keep a group chat but lose the small shared moments. We haven't measured
  this yet. It's assumption A-03 in the [assumptions list](08-risks-and-assumptions.md).
- **Fact.** Products built around small, shared daily moments have reached
  very large audiences: Wordle's one puzzle a day [S-03], BeReal's daily
  prompt [S-01], and Locket's photos from close friends on the home screen
  [S-14].
- **Fact.** Social connection motivates people. Strava's research found
  social connection was the top reason people exercise with others [S-11],
  and a study of Strava clubs found that receiving kudos was linked to running
  more [S-10].

## The opportunity

No product we found combines all three of these:

1. **Real self-tracking data** as game material
2. A **social-deduction** mechanic (bluffing and catching bluffs)
3. A **small private circle** with a daily ritual and a periodic recap

Screen-time apps compare numbers. Party games use made-up prompts. Daily games
are solitary with a share button. BLAG sits in the gap. See the
[competitive landscape](07-competitive-landscape.md).

## Why now

- **Estimate.** Phone use in our first market is high and is a common topic of
  conversation [S-19].
- **Fact.** Year-in-review recaps are a mainstream habit. Spotify reported more
  than 200 million engaged users and about 500 million shares in the first day
  of Wrapped 2025 [S-07], and added a "Wrapped Party" feature for comparing
  with friends [S-08].
- **Fact.** Both phone platforms already show users their own screen time, so
  the numbers exist. iOS doesn't let other apps export them, which shapes how
  BLAG collects data (see [mobile dependencies](../mobile-dependencies/README.md)).

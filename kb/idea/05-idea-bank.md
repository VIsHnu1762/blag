# 05 · Idea bank

Status: **Living document**. Last updated: 2026-11-04.

Every idea collected so far, from the original spec, the design discussions,
the team round table and the [inspiration library](04-inspiration-library.md).
Nothing here is committed until it moves to the [decision log](10-decision-log.md).

**Release tags:** `MVP` (first playable version) · `Next` (soon after) ·
`Later` · `Research` (needs a feasibility check) · `Cut` (decided against, kept
for the record).

**Source tags:** `Spec` (original brief) · `Talk` (design discussions) ·
`Table` (round table) · `Insp` (inspiration library).

## Core game

| ID | Idea | Source | Release | Notes |
|---|---|---|---|---|
| P-01 | **Classic Bluff round**: claim → True/Bluff vote → reveal → points | Spec | MVP | The heart of BLAG |
| P-02 | **Daily drop** for each circle, open for 24 hours | Talk, Insp (Wordle, BeReal) | MVP | Replaces 8–12-round sessions |
| P-03 | **Monthly league** with a fresh start each season | Talk, Insp (Duolingo) | MVP | Points from skill only |
| P-04 | **Monthly finale** where every member gets a play-style title | Talk | MVP | No habit-based titles |
| P-05 | **Guess the number** as well as True/Bluff, with points for closeness | Spec | MVP | Adds skill depth |
| P-06 | **Guess yourself**: before seeing your own stat, guess it. Closest to your own truth earns a point | Insp (self-report research) | Next | Turns the "we misjudge ourselves" finding into play |
| P-07 | **Daily twist cards**: one small rule change a day (double stakes, everyone bluffs, silent round) | Table | Next | Keeps the loop fresh |
| P-08 | **Beat the house**: the whole circle plays together against the app | Table | Later | Gives quieter members an easy way in |
| P-09 | **Knowing score** between each pair of friends, built over a season | Spec (Who Knows Me Best), Table | Next | Long-term reason to stay |
| P-10 | **Closest pair / digital twins** reveal at the finale | Spec | Next | Fun, low-stakes |
| P-11 | **Live mode**: same room, shared screen, phones as controllers | Spec (Pass-the-Phone), Insp (Jackbox) | Next | Option of a web join |
| P-12 | **Pass-the-phone** on one device | Spec | Later | Live mode may cover this |
| P-13 | **Hot Seat** in its original form (20 seconds to defend a stat) | Spec | Cut | Feels like a courtroom. Could return as a friendly "explain your number" with no time pressure |

## Fairness and trust

| ID | Idea | Source | Release | Notes |
|---|---|---|---|---|
| P-14 | **Seal before you claim**: the real number is locked before the claim and votes | Table | MVP | Key to fairness with typed-in numbers |
| P-15 | **Trust tiers**: typed, screenshot, or synced stats, each with a small bonus | Table | Next | Verification becomes part of the game |
| P-16 | **Screenshot proof badge** with no OCR | Spec | MVP | Optional |
| P-17 | **Server-side scoring** so nobody can read hidden values early | Spec | MVP | Architecture requirement |

## Comfort and privacy

| ID | Idea | Source | Release | Notes |
|---|---|---|---|---|
| P-18 | **Per-stat opt-in**, with extra opt-in for sensitive stats | Spec | MVP | |
| P-19 | **Invisible pass**, indistinguishable from a random skip | Talk | MVP | |
| P-20 | **Neutral "away" status**, no missed-day count | Talk | MVP | |
| P-21 | **Sealed claims** left in advance for days away | Talk | Next | |
| P-22 | **Catch-up card** when you return | Talk | MVP | |
| P-23 | **Rest day**: one non-stat prompt a week | Table | MVP | Ritual never depends on numbers |
| P-24 | **Private weekly mirror**: a neutral note against your own baseline | Table | Next | Only you see it |
| P-25 | **Emoji-only reactions** during rounds, never counted | Spec, Insp (Locket) | MVP | |
| P-26 | **Delete my data** and leave a circle at any time | Spec | MVP | Store requirement too |

## Personal layer

| ID | Idea | Source | Release | Notes |
|---|---|---|---|---|
| P-27 | **Focus lanes**: fitness, less social media, sleep, productivity, just for fun | Talk | MVP | Decides what each player's claims are about |
| P-28 | **My month** (private) vs **our month** (shared) | Talk | MVP | Stories, not numbers, connect them |
| P-29 | **"My four"** mini-profile: four favourite things | Insp (Letterboxd) | Later | Identity without stats |

## Memory and sharing

| ID | Idea | Source | Release | Notes |
|---|---|---|---|---|
| P-30 | **Share card** with no raw stats | Spec, Insp (Wordle) | MVP | Growth engine |
| P-31 | **Group Wrapped** monthly recap | Spec, Insp (Spotify) | Next | |
| P-32 | **Circle yearbook**: season archive of best bluffs and inside jokes | Table | Later | The real moat |
| P-33 | **Milestone rounds** for birthdays and anniversaries | Table | Later | |
| P-34 | **Home-screen widget** with today's drop | Insp (Locket) | Later | |

## Growth

| ID | Idea | Source | Release | Notes |
|---|---|---|---|---|
| P-35 | **Invite circles, not individuals**: one invite link for the whole group | Table | MVP | Solves cold start |
| P-36 | **Contact sync** to find friends | Talk | Later | Third-party data; off by default; no auto-invites (D-07) |
| P-37 | **Circle vs circle** friendly matches | Table | Later | Only once circles are stable |

## Other daily card types (after the core works)

| ID | Idea | Source | Release | Notes |
|---|---|---|---|---|
| P-38 | **Movie card**: rate a film, guess each other's rating | Talk, Insp (Letterboxd) | Later | No sensitive data |
| P-39 | **Meme card**: pick the meme that fits a friend | Talk | Later | Needs content moderation thinking |
| P-40 | **Music card**: guess whose song is whose | Talk | Later | Licensing check needed |
| P-41 | **Productivity card**: claims about focus time, tasks done | Talk | Later | Fits a focus lane |
| P-42 | **Short voice claims** | Table | Research | Needs privacy review |
| P-43 | **Shared circle goal**, e.g. a phone-free dinner | Insp (Forest, Habitica) | Later | Opt-in, never a group punishment |
| P-44 | **Real-world good at the finale** (e.g. a tree planted for an active circle) | Insp (Forest) | Research | Strong impact story; needs a partner and funding |

## Data sources

| ID | Idea | Source | Release | Notes |
|---|---|---|---|---|
| P-45 | **Manual entry** from the phone's own screen-time page | Spec | MVP | Works everywhere |
| P-46 | **Android auto-read** of app usage with the user's permission | Spec | Research | Permission is granted in system settings |
| P-47 | **iOS auto-read** of Screen Time | Spec | Research | Apple doesn't let apps export these numbers; likely not possible |
| P-48 | **Steps** from Apple Health / Health Connect | Spec | Research | Health data rules apply |

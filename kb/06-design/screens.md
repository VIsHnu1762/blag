---
id: design.screens
title: Screens
section: 06-design
status: draft
summary: "Inventory of the 16 MVP screens: purpose, key contents, primary action, and the empty, loading and error states each needs."
order: 2
last_updated: 2026-11-04
audience: [design, developers, agents]
related: [design.flows, registers.features, users.journeys]
---

# Screens

> **In short:** sixteen MVP screens, each with one job; wireframes still to be drawn.

## Inventory

| # | Screen | Job | Key contents | Primary action | Feature |
|---|---|---|---|---|---|
| S1 | Welcome | Explain BLAG in 3 cards | What it is; "a game, not a judgement"; privacy promise | Get started | F-01 |
| S2 | Sign up | Create account | Sign-in options (Q-13); 18+ confirmation | Continue | F-01 |
| S3 | Home | See circles and today's state | Circle cards with today's status ("Reveal at 9pm") | Open circle | — |
| S4 | Create circle | Set up a circle | Name, home time zone, drop and reveal times | Create | F-02 |
| S5 | Invite | Bring friends | Link, QR, share sheet, members so far | Share | F-02 |
| S6 | Join | Accept an invite | Circle name, organiser, member count | Join | F-03 |
| S7 | Stats and lane | Choose what to share | Focus lane picker; stats grouped by family; extra confirm for spicy and health | Save | F-04 |
| S8 | Today (drop) | The day's game hub | Secret Speaker placeholder, or the claim; read status; reveal time | Read / Seal | F-05 |
| S9 | Seal | Enter the real number | Topic; where-to-find help per platform; number pad; screenshot | Seal | F-06 |
| S10 | Claim | Make the claim | Truth zone; number pad; "This is a TRUTH / BLUFF" indicator | Claim | F-06 |
| S11 | Read | Call it | Claim card; TRUE / BLUFF buttons; optional guess | Lock in | F-07 |
| S12 | Reveal | The show | Count-up number, stamp, everyone's reads and guesses, points, reactions | React | F-08, F-09 |
| S13 | League | Season standings | Members by season score; joint positions; days left | — | F-10 |
| S14 | Finale | End of season | Positions, titles dealt in, moments, share card | Share | F-11, F-12 |
| S15 | My month | Private reflection | Own values over time, neutral notes | — | F-16 |
| S16 | Settings and privacy | Control | Notifications, quiet hours, stats, leave circle, delete account, privacy policy | — | F-17, F-18 |

Rest days reuse S8 and S11 with a "who in the circle" picker. The catch-up card
(F-14) is a sheet over S8.

## States every screen needs

| State | Rule |
|---|---|
| Loading | Skeletons, not spinners, for lists; never block the whole screen |
| Empty | Friendly and actionable, e.g. League before the first reveal: "The league starts after tonight's reveal." |
| Offline | Show the last known state with a small "offline" pill; queue actions with idempotency keys |
| Error | Calm, practical copy ([voice](../05-brand/voice-and-tone.md)); always a retry |
| Paused circle | "Drops start again when there are 3 of you." with an invite button |

## Details worth getting right

- **S8 Today:** before the claim it must not reveal who the Speaker is, even to the Speaker on a shared screen. Show the Speaker's private view only after they tap.
- **S9 Seal:** platform-specific help: a short line and a small screenshot of where the number lives on iPhone and Android ([find-your-number study](../02-users/research-plan.md)).
- **S10 Claim:** the TRUTH/BLUFF indicator updates live as the Speaker types, so a bluff is always deliberate.
- **S12 Reveal:** works in reduced-motion mode; the stamp is readable without colour ([accessibility](accessibility.md)).
- **S13 League:** no "behind by" numbers; no arrows.

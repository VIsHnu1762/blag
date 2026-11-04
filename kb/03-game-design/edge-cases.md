---
id: game.edge
title: Edge cases
section: 03-game-design
status: proposal
summary: "What happens in unusual situations: zero values, joins and leaves mid-day, everyone passing, time-zone changes, network failures and more."
order: 7
last_updated: 2026-11-04
audience: [developers, product, agents]
related: [game.rules, game.state, game.scoring]
---

# Edge cases

> **In short:** a checklist of awkward situations and the rule for each; every row should become a test.

| # | Situation | Rule |
|---|---|---|
| E-1 | Seal is 0 | Truth zone is the stat's floor (e.g. 0–5 minutes) |
| E-2 | Seal is far outside normal range (e.g. 2,000 minutes screen time) | Reject values above the stat's maximum (24h for daily time, 100,000 steps); ask to re-check |
| E-3 | Speaker realises the seal had a typo | Can edit until they claim; locked after |
| E-4 | Speaker typed a false seal on purpose | Can't be detected for typed values; it only spoils their own game. Screenshot proof discourages it |
| E-5 | Nobody reads | Speaker scores 0; round still reveals at reveal time |
| E-6 | Only one reader | Normal scoring; that reader is automatically "closest" if they guessed |
| E-7 | Everyone passes as Speaker | Rest round |
| E-8 | Member joins after the drop opened | Can read today's claim; not chosen as Speaker until tomorrow |
| E-9 | Member leaves while a round is CLAIMED | Their read is removed; if they were Speaker, the round still reveals and scores readers |
| E-10 | Circle drops to 2 members | Drops pause; a friendly note invites a third friend |
| E-11 | Organiser changes the reveal time mid-day | Applies from tomorrow |
| E-12 | Organiser changes the home time zone | Applies from the next drop; no drop is skipped or doubled |
| E-13 | Daylight-saving change | Times stay at the same local clock time; computed in the zone database, never fixed offsets |
| E-14 | Member travels to another time zone | Circle times don't change; the app shows them in the member's new local time |
| E-15 | Network fails while submitting a read | Client retries with the same idempotency key; server accepts once |
| E-16 | Two devices on one account read differently | Last write before the reveal wins |
| E-17 | Reveal happens while a member is offline | They see it next time they open the app; no notification spam |
| E-18 | Member turns off the stat that is today's topic after being chosen | Treated as a pass; backup chosen |
| E-19 | Member deletes their account mid-season | Their rows are deleted; past revealed rounds show "a former member"; league recalculates without them |
| E-20 | Last day of month at 23:59 | The drop belongs to the season of its local date |
| E-21 | Circle created mid-month | Short first season; best-20 rule unchanged |
| E-22 | Two readers tie for closest guess | Both get +1 |
| E-23 | Guess is identical to the claim | Allowed; scored normally |
| E-24 | Claim equals the zone edge | Inside the zone counts as true (inclusive) |
| E-25 | Clock on the phone is wrong | The server's time is always used |

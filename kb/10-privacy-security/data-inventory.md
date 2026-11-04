---
id: privacy.inventory
title: Data inventory
section: 10-privacy-security
status: draft
summary: "Every type of data BLAG would store, its purpose, who can see it, where it lives and how long it's kept."
order: 1
last_updated: 2026-11-04
audience: [developers, product, agents]
related: [privacy.home, arch.data, privacy.compliance]
---

# Data inventory

> **In short:** a table of everything BLAG stores; if a piece of data isn't here, the app must not collect it.

Retention periods are *(Proposal)* pending Q-17 and legal review.

| Data | Purpose | Who can see it | Stored in | Kept for |
|---|---|---|---|---|
| Email or sign-in id | Sign-in, recovery | Member; system | Supabase Auth | Until account deletion |
| Display name, avatar colour | Show who's who | Circle members | `profiles` | Until account deletion |
| 18+ confirmation time | Age gate record | System | `profiles` | Until account deletion |
| Circle membership, lane, paused flag | Run the game | Circle (paused flag: only the member) | `circle_members` | Until the member leaves + season end |
| Stat consents | Respect choices | Member | `stat_consents` | Until account deletion |
| **Sealed value** | Decide truth | **Nobody until reveal**, then the circle | `private.seals` → `round_results` | Seal row: deleted 30 days after reveal; revealed value: season end + 90 days (Q-17) |
| Screenshot proof | Optional trust | Circle, after reveal | Storage | 30 days after reveal |
| Claim | The game | Circle, after claim | `claims` | Season end + 90 days |
| Reads and guesses | Scoring | Own always; circle after reveal | `reads` | Season end + 90 days |
| Points, day scores, titles | League and finale | Circle | `round_results`, `day_scores`, `titles` | While the circle exists (titles and moments form the circle's history, without stat values) |
| Reactions | Fun | Circle, after reveal | `reactions` | Season end + 90 days |
| Push token | Notifications | System | `push_tokens` | Until sign-out or deletion |
| Crash reports | Fix bugs | Team | Crash tool | 90 days; personal data scrubbed |
| Product analytics | Measure retention | Team (aggregated) | Analytics tool | 12 months; **never stat values** |

## Never collected

- Usage history, app lists or per-hour data beyond the one sealed number
- Contacts (MVP)
- Location
- Messages or chat content
- Advertising identifiers

## Deletion

| Trigger | Result |
|---|---|
| Member deletes account | All rows tied to the member are deleted within 30 days *(Proposal)*; their points in past results are re-keyed to an anonymous id shown as "a former member" |
| Member leaves a circle | Future data stops; past round data follows the normal retention |
| Retention period ends | Scheduled cleanup job deletes or anonymises rows |
| Circle deleted by organiser | All circle game data deleted; members' accounts remain |

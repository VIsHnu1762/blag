---
id: privacy.threats
title: Threat model
section: 10-privacy-security
status: draft
summary: "Assets, attackers and threats to BLAG (cheating, leaks, account abuse, harassment), with mitigations and remaining risk."
order: 2
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.fairness, privacy.home, quality.home]
---

# Threat model

> **In short:** the biggest risks are hidden values leaking before the reveal and people inside a circle making someone uncomfortable; both are handled by design, not by moderation.

Approach: list assets, list who might attack them, then go through threats
(loosely STRIDE). Security testing follows OWASP MASVS (D-12).

## Assets

| Asset | Why it matters |
|---|---|
| Sealed values before reveal | The whole game's fairness |
| Reads before reveal | Fairness |
| Who passed or was away | Comfort promise |
| Members' stat history | Privacy promise |
| Accounts | Access to circles |
| Invite codes | Access to circles |

## Who might attack

| Actor | Motive |
|---|---|
| Curious circle member | Peek at the truth or others' reads early |
| Competitive member | Win by manipulating points |
| Outsider | Join a circle uninvited; scrape data |
| Person with a grudge | Embarrass a member |

## Threats and mitigations

| # | Threat | Mitigation | Remaining risk |
|---|---|---|---|
| T-1 | Member reads a seal early through the API | Seals in `private` schema; no client grant; tests | Bug in policies → automated tests on every change |
| T-2 | Member reads others' reads before reveal | Row-level security on `revealed_at` | Same |
| T-3 | Modified app sends fake points or reveals | Server-only scoring and state (ADR-003) | Low |
| T-4 | Replay or double submission | Idempotency keys; unique constraints | Low |
| T-5 | Guessing invite codes | Long random codes, stored hashed, rate-limited joins, resettable | Low |
| T-6 | Realtime event leaks data | Private channels; payloads carry ids only | Low |
| T-7 | Speaker identity leaks through a notification preview | Generic lock-screen text (N-1 rule) | Medium: test on both platforms |
| T-8 | Account takeover | Provider sign-in or one-time codes; no passwords stored by BLAG | Depends on Q-13 |
| T-9 | Screenshot proof reveals extra private info | Warn to crop; visible only after reveal; deleted after 30 days | Medium: member choice |
| T-10 | A member is targeted by the circle | No free text; emoji only; secret Speaker; invisible pass; can leave any time | Social: can't be fully solved by software |
| T-11 | Under-18 signs up | 18+ confirmation; no features aimed at minors | Medium: self-declared (Q-03) |
| T-12 | Leaked service key | Keys only in server environment; never in the app; rotation plan | Low |
| T-13 | Stat values in logs or analytics | Logging rules: never log values; scrub crash reports | Medium: code review checklist |
| T-14 | Data kept too long | Scheduled retention cleanup | Low once built |

## Security checklist for the MVP

- [ ] Row-level security on every public table, tested
- [ ] No service-role key in the app bundle
- [ ] All Edge Functions verify the caller and circle membership
- [ ] Idempotency keys and rate limits on all actions
- [ ] No stat values in logs, analytics or crash reports
- [ ] Dependency scanning on the repository
- [ ] OWASP MASVS-L1 self-assessment before the beta

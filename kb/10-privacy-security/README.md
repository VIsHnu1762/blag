---
id: privacy.home
title: Privacy and security
section: 10-privacy-security
status: draft
summary: "BLAG's privacy promises and security approach, with links to the data inventory, threat model and compliance map."
last_updated: 2026-11-04
audience: [everyone, developers, judges, agents]
related: [privacy.inventory, privacy.threats, privacy.compliance, arch.fairness]
---

# Privacy and security

> **In short:** BLAG collects the least data a game needs, shares a number only inside your circle and only when you choose, and lets you delete everything at any time.

## Privacy promises (what we tell members)

1. **You choose every stat.** Nothing is shared unless you turn it on.
2. **Only your circle sees a revealed number,** and only the one number from that round.
3. **Your history is yours.** Nobody else can see your past numbers.
4. **Passing and taking breaks are invisible.**
5. **No usage history leaves your phone.** We store only the numbers you seal.
6. **No ads, no selling data.**
7. **Delete everything, any time,** in the app or on the web.

These promises are product requirements. Breaking one is a red-line breach
([principles](../01-idea/05-principles-and-red-lines.md)).

## Privacy by design, in practice

| Principle | How BLAG applies it |
|---|---|
| Data minimisation | One value per round; no raw usage history; no real name required |
| Purpose limitation | Stats are used only for the game and the member's own "my month" |
| Consent | Per-stat opt-in; extra confirmation for spicy and health stats |
| Visibility control | Row-level security; seals in a private schema ([fairness](../07-architecture/sealing-and-fairness.md)) |
| Storage limitation | Retention periods per data type ([inventory](data-inventory.md)) |
| Right to erasure | In-app and web deletion (F-18) |
| Security | Server-authoritative design, idempotent actions, least-privilege keys ([threat model](threat-model.md)) |

## Pages

| Page | What it covers |
|---|---|
| [Data inventory](data-inventory.md) | Every piece of data, why we keep it, who sees it, how long |
| [Threat model](threat-model.md) | What could go wrong and how it's prevented |
| [Compliance map](compliance.md) | Laws, store rules and standards, and what each requires of BLAG |

**Note:** this KB records the team's understanding. It isn't legal advice.
Get a qualified review before launch.

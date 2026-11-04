---
id: roadmap.home
title: Roadmap
section: 12-roadmap
status: proposal
summary: "Six phases from knowledge base and hand-run test to prototype, MVP, closed beta and launch, with goals, deliverables and exit criteria."
last_updated: 2026-11-04
audience: [everyone, judges]
related: [idea.validation, features.mvp, registers.features]
---

# Roadmap

> **In short:** prove people want it by hand, build a demo, build the MVP, test with real circles, then launch; each phase has an exit test.

Durations are *(Estimates)* for a small student team working part-time.

## Phases

| Phase | Goal | Main deliverables | Exit when | Duration |
|---|---|---|---|---|
| **0. Knowledge base** | Agree what BLAG is | This KB; decisions on Q-03, Q-13, Q-14 | Readiness gate in the [KB home](../README.md#readiness-gate) is mostly ticked | 1–2 weeks (now) |
| **1. Hand-run test** | Prove the loop is wanted | Two weeks in WhatsApp with 3 groups ([plan](../01-idea/07-validation-plan.md)), run **alongside** the first two build weeks (D-45) | A-01, A-02, A-04, A-05 pass | 2–3 weeks |
| **2. Prototype** | A demo for the hackathon and usability tests | One circle, manual stats, seal → claim → read → reveal, scoring; minimal UI | Usability test with 6–8 people done | 2–3 weeks |
| **3. MVP** | A whole month playable by real circles | All MVP features ([scope](../04-features/mvp-scope.md)); privacy and deletion; notifications | Definition of done met for every MVP feature | 6–8 weeks |
| **4. Closed beta** | Learn retention over a full season | 10–20 circles across 2–3 colleges; Android first via internal testing, iOS via TestFlight | A-06 and A-08 measured; no red-line breaches reported | 1–2 seasons |
| **5. Launch** | Public release in India | Store listings; privacy policy; support page; legal review done | Compliance checklist done ([compliance](../10-privacy-security/compliance.md)) | — |

No deadline and no sprints for now; work happens on `main` (D-35).

## Release documents, drafted alongside the build (D-46)

| Document | Drafted during | Source |
|---|---|---|
| Privacy policy | Prototype | [Data inventory](../10-privacy-security/data-inventory.md) |
| Terms of use (zero-tolerance line) | Prototype | Apple 1.2 [S-80] |
| Account-deletion web page | MVP | `apps/web/delete-account.html` (F-18) |
| Support page and contact email | MVP | F-24 |
| Apple privacy label, Google Data safety form | MVP | Data inventory |
| Age-rating questionnaires | Beta | 18+ (D-27) |
| Name and trademark check | Now, before the store listing | D-01 |
| Grievance contact (DPDP) | MVP | [Compliance](../10-privacy-security/compliance.md) |
| Store listing: category Games > Casual (D-37) | Beta | — |

## After launch (Next and Later)

| Release | Candidates |
|---|---|
| Next | Guess yourself (F-19), knowing score (F-20), live mode (F-21), Group Wrapped (F-22), twist cards (P-07) |
| Later | Android auto-read (F-23), health data, yearbook (P-32), movie and meme cards (P-38, P-39), widget (P-34) |

## Hackathon track (if the deadline is close)

If a hackathon demo is due before the hand-run test ends, build **Phase 2**
first and run Phase 1 in parallel. The demo needs only: create a circle with
pre-made members, one Speaker turn, three reads, the reveal animation, and the
finale with titles. See the [pitch kit](../13-pitch/README.md).

## Metrics to track from the beta

| Metric | Why | Target *(Proposal)* |
|---|---|---|
| Circles still playing in week 4 | Retention, A-06 | Most circles |
| Days with 3+ members reading | Ritual strength | Most days |
| Median daily time in app | Ten-minute promise | 5–15 minutes in total |
| Share cards posted | Growth, A-08 | Tracked, no target yet |
| Passes per member per week | Comfort signal | Watch, don't optimise |
| Reports of feeling judged | Red-line health | Zero tolerated without a fix |

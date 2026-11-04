---
id: design.accessibility
title: Accessibility
section: 06-design
status: proposal
summary: "WCAG 2.2 AA requirements applied to BLAG's screens, plus inclusion for low-end phones, patchy data and different languages."
order: 4
last_updated: 2026-11-04
audience: [design, developers]
related: [brand.visual, design.screens, quality.home]
---

# Accessibility

> **In short:** BLAG targets WCAG 2.2 AA (D-12); the reveal, stamps and number entry get special attention because they're the heart of the game.

## Requirements

| Area | Requirement | BLAG specifics |
|---|---|---|
| Contrast | Text 4.5:1, large text and UI parts 3:1 | Measured for every token in [visual identity](../05-brand/visual-identity.md); purple only for large text |
| Not colour alone | Meaning never relies only on colour | TRUTH and BLUFF! differ in word, shape and icon (✓ vs ✗) |
| Text size | Support system font scaling to 200% | Number pads and stamps reflow; no truncated claims |
| Touch targets | At least 24×24 px (WCAG 2.2), aim for 44×44 | TRUE / BLUFF buttons are full-width |
| Screen readers | Every control labelled; reading order logical | Reveal announces: "Revealed: 8,000 steps. Bluff. You read Bluff: correct, plus 2." |
| Motion | Respect reduce-motion | Calm reveal variant ([visual identity](../05-brand/visual-identity.md#motion)) |
| Timing | No action needs fast reactions in async play | Live mode (later) must allow extending its timer |
| Focus | Visible focus ring on every interactive element | Purple ring, 3:1 against background |
| Errors | Explained in text, with how to fix | "That number looks too high for steps. Check it?" |
| Haptics and sound | Never the only feedback | Every haptic has a visual equivalent |

## Inclusion beyond WCAG

| Need | Plan |
|---|---|
| Mid-range and older Android phones | Keep the reveal animation light; test on a 3–4 GB RAM device |
| Patchy data | Small payloads; offline queue; images compressed |
| Languages | English first; copy kept in string files from day one for translation |
| Number formats | Respect locale grouping (e.g. Indian 1,00,000 vs 100,000) *(Proposal)* |
| Colour blindness | Check stamps under protanopia, deuteranopia and tritanopia simulation |

## Testing

- Automated: lint for missing labels; contrast checks on tokens.
- Manual: VoiceOver (iOS) and TalkBack (Android) run-through of S8–S12 before each release.
- Include at least one participant who uses a screen reader in usability tests if possible.

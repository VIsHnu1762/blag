---
id: brand.visual
title: Visual identity
section: 05-brand
status: proposal
summary: "Proposed colour tokens with measured WCAG contrast, typography, shape, motion, sound and haptics for BLAG."
order: 2
last_updated: 2026-11-04
audience: [design, developers]
related: [brand.home, design.accessibility, design.emotional]
---

# Visual identity

> **In short:** a dark "poker night" base with electric yellow and hot coral accents, big tabular numbers, and one signature animation: the stamp.

Status: **Proposal** (Q-05). Based on the original brief's purple, yellow and
coral, refined for contrast.

## Colour tokens (dark theme, default)

| Token | Hex | Use |
|---|---|---|
| `bg/night` | `#140F24` | App background |
| `bg/surface` | `#211936` | Cards |
| `bg/raised` | `#2E2448` | Sheets, inputs |
| `text/primary` | `#F6F3FF` | Body text |
| `text/muted` | `#B9B0D3` | Secondary text |
| `brand/purple` | `#8B5CF6` | Large accents, focus rings (not body text) |
| `brand/purple-deep` | `#4C1D95` | Buttons with light text |
| `accent/yellow` | `#FFD43B` | Primary action, **TRUTH** stamp |
| `accent/coral` | `#FF6B57` | **BLUFF!** stamp, highlights |
| `accent/mint` | `#4ADE80` | Success confirmations |

### Measured contrast

Computed with the WCAG 2 formula. AA needs **4.5:1** for normal text and **3:1**
for large text and UI parts.

| Foreground on background | Ratio | Result |
|---|---|---|
| text/primary on bg/night | 17.1 | Pass AAA |
| text/primary on bg/surface | 15.3 | Pass AAA |
| text/muted on bg/surface | 8.1 | Pass AAA |
| accent/yellow on bg/night | 13.1 | Pass AAA |
| accent/coral on bg/night | 6.7 | Pass AA |
| accent/coral on bg/surface | 6.0 | Pass AA |
| bg/night on accent/yellow (button text) | 13.1 | Pass AAA |
| text/primary on brand/purple-deep | 10.0 | Pass AAA |
| brand/purple on bg/night | 4.4 | **Large text and UI parts only** |
| text/primary on brand/purple | 3.9 | **Large text only**; use purple-deep for buttons |

A light theme (ink `#1A1530` on paper `#FBF8FF`, 16.7:1) is available for
people who prefer it.

### Colour rules

- TRUTH and BLUFF! must differ in **word and shape** as well as colour (see [accessibility](../06-design/accessibility.md)).
- Never use red/green or up/down arrows for personal data (D-10).
- Coral is for the game's BLUFF moment, never for "bad" numbers.

## Typography

| Role | Proposal | Why |
|---|---|---|
| Display (stamps, big numbers) | **Bricolage Grotesque**, extra bold | Characterful, playful; open licence (OFL) |
| UI and body | **Inter** | Highly legible; **tabular figures** so counting-up numbers don't jitter |
| Numbers | Inter with `tnum` | Fixed-width digits during the reveal |

Both are free Google Fonts under the SIL Open Font License *(verify before shipping)*.
Support system font scaling up to 200% ([accessibility](../06-design/accessibility.md)).

## Shape

- Rounded corners: 16 px cards, 999 px pills for buttons.
- The **stamp** is a rotated (−8°) rounded rectangle with a rough ink edge, like a rubber stamp.
- Avatars are circles with a 2 px ring in the member's chosen colour.

## Motion

| Moment | Motion | Reduced-motion version |
|---|---|---|
| Reveal number | Counts up over ~1.2 s | Number appears with a fade |
| Stamp | Drops in with a small bounce and a slight shake | Fades in |
| Read locked | Card flips | Check mark appears |
| Finale titles | Cards deal in one by one | Shown as a list |

## Sound and haptics

| Moment | Sound | Haptic |
|---|---|---|
| Read locked | Soft chip click | Light tap |
| Stamp lands | Rubber-stamp thud | Medium impact |
| Fooled everyone | Short card-shuffle flourish | Success pattern |

Sounds off by default *(Proposal)* with a clear toggle; haptics follow the system setting.

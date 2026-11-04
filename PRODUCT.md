# Product

<!-- impeccable:product-schema 1 -->

## Platform

adaptive

## Stack

Expo + React Native + TypeScript (Expo Router, Reanimated) for iOS and Android from one codebase (D-19, ADR-001). Backend on Supabase (ADR-002). Public web pages are plain static HTML under 30 KB each (D-31). Full detail: `kb/07-architecture/repository-structure.md`.

## Users

Close friend circles of 3 to 8 people, roughly 18 to 30, who may or may not live near each other; first market is likely university friend groups in India, where about 93% of phones run Android (D-13). They already live in group chats and social apps and use some productivity or habit apps. Their job: a short daily reason to play with and learn about their friends, about 10 minutes a day. 18+ only (D-27).

## Product Purpose

BLAG: Are You Bluffing? is a privacy-first daily social bluffing game. Each day a secret Speaker seals a real habit number (screen time, steps…), then claims a number; friends call TRUE or BLUFF and guess; the sealed number is revealed. Points reward reading your friends, never your habits. Daily drops build into a monthly league with a finale where everyone gets a title. Success: circles that play most days for a whole season without anyone feeling guilt or pride about their habits.

## Positioning

The real number is sealed before the claim, so a bluff is a real bluff and the reveal is earned (ADR-003). Scoring rewards social reading, so nobody is structurally last because of their habits (D-05). Missed days cost nothing and are never shown (D-08, D-16).

## Operating Context

A daily ritual in the circle's home time zone: drop opens (08:00 by default), the Speaker seals and claims before a cutoff, friends read until the reveal (21:00 by default, or earlier when everyone has read). One or two rounds a day per circle (D-29). Invites travel through WhatsApp and other chats as links and QR codes. Phones are used one-handed, often in short gaps during the day.

## Capabilities and Constraints

- Screens split by mode (D-24): Operate screens (sign-in, settings, invite, members, notifications) follow iOS and Android conventions; Experience screens (seal, claim, read, reveal, finale) carry BLAG's own look, motion and sound.
- Design starts low-fidelity: greyscale, system font, real copy, proper layout. Colours, fonts and brand visuals come only after the core game works (D-36).
- Motion: Reanimated now; Rive later (D-33). React Bits is inspiration only, never ported (D-25).
- In-app words differ from code names (D-23): Today's Drop, Lock it in, Call it, Season Wrap, Receipts. See `kb/06-design/ux-language.md`.
- Free text only in display and circle names; reactions are a fixed emoji set; Report and Block exist (D-42).
- iPhone stats are typed in (no Screen Time access, D-34); steps and sleep are typed in the MVP (D-39).
- Undecided: final palette and typefaces (Q-05, parked until the core works).

## Brand Commitments

- Name: "BLAG: Are You Bluffing?" (D-01), chosen for uniqueness, not British slang; copy stays neutral and international (D-02).
- Voice: playful, teasing between friends, never shaming. See `kb/05-brand/voice-and-tone.md`.
- The existing purple, yellow and coral tokens in `kb/05-brand/visual-identity.md` are a starting point, not binding (Q-05 parked).

## Evidence on Hand

Research and decisions in `kb/` (ideas, competitive landscape, personas, journeys, game rules with worked examples). No real users, testimonials, metrics, screenshots or press exist yet; do not invent any. The two-week WhatsApp test runs alongside the first build weeks (D-45) and will be the first real evidence.

## Product Principles

1. Read your friends, not their habits: points never come from stat values.
2. No guilt, no pride: no streak loss, no missed-day counts, no public ranking of habits.
3. Fair by construction: seal before claim; the server decides.
4. Ten minutes a day, then put the phone down: notifications only when something real happened.
5. Private by default: the least data, held the shortest time; the sealed number is deleted at the reveal.

## Accessibility & Inclusion

WCAG 2.2 AA (D-12). Touch targets at least 44 pt (iOS) and 48 dp (Android); Dynamic Type and Android font scaling respected; Reduce Motion gets a calm alternative to every reveal animation; dark mode first-class. English first with Indian number formats; copy written so it can be localised. See `kb/06-design/accessibility.md`.

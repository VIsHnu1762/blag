---
id: stack.home
title: Tech stack
section: 08-tech-stack
status: proposal
summary: "Proposed tools for every layer of BLAG (app, backend, scheduling, notifications, testing, docs) with reasons, alternatives and open choices."
last_updated: 2026-11-04
audience: [developers, agents, judges]
related: [stack.benchmarks, arch.home, adr.001, adr.002, mobile.home]
---

# Tech stack

> **In short:** TypeScript everywhere: Expo and React Native for the app, Supabase for the backend, a shared pure game engine, and managed services wherever possible.

Status: **Proposal**, except the app framework: **Expo + React Native is decided** (D-19, ADR-001). Each choice links to its ADR when there is one.

**Benchmark:** see [industry benchmarks](industry-benchmarks.md) for what Snapchat,
Duolingo, Wordle, BeReal, Discord, Bluesky and others use, and why BLAG keeps
Expo for the MVP but reviews it after the prototype (D-19, Q-18).

## The stack

| Layer | Choice | Why | ADR |
|---|---|---|---|
| Language | **TypeScript** | One language across app, game engine and Edge Functions | — |
| App framework | **React Native + Expo** (current SDK at kick-off; SDK 56 shipped React Native 0.85 in May 2026 [S-42]) | One codebase for Android and iOS; Expo Modules for native code | ADR-001 |
| Navigation | Expo Router | File-based routes; standard in Expo | — |
| Builds and releases | EAS Build and EAS Submit | Managed signing and store uploads | ADR-001 |
| Backend | **Supabase**: Postgres, Auth, Edge Functions, Realtime, Storage | All-in-one; SQL with row-level security fits hidden values | ADR-002 |
| Scheduling | `pg_cron` + `pg_net` calling Edge Functions [S-43] | Drops and seasons on a clock | ADR-005 |
| Realtime | Supabase Realtime private channels [S-44] | Per-circle events, members only | ADR-002 |
| Game engine | Pure TS package shared by app and Edge Functions | Rules tested once, used everywhere | ADR-003 |
| Push | Expo push notifications → APNs / FCM | One API for both platforms | — |
| Animation | React Native Reanimated; prototype the stamp in Rive (Q-19) | Smooth reveal on mid-range phones; Duolingo uses Rive for characters [S-50] | — |
| Haptics | expo-haptics | Built in | — |
| Local storage | Expo SecureStore (tokens), AsyncStorage or SQLite (offline queue) | Secure tokens; queued actions | — |
| Analytics | Privacy-first, self-hostable option (e.g. PostHog) with no stat values sent *(Proposal)* | Measure retention without collecting habits | — |
| Crash reporting | Sentry (Expo integration) with personal data scrubbing *(Proposal)* | Find crashes fast | — |
| Testing | Vitest (game engine), pgTAP or SQL tests (row-level security), Maestro (end-to-end flows) | See [quality](../11-quality/README.md) | — |
| Docs | This KB: Markdown + YAML, `scripts/kb.py`, MkDocs Material site | People and agents read the same files (D-14) | — |

## Native work (later, not MVP)

| Need | Approach |
|---|---|
| Android app usage | Kotlin Expo Module wrapping `UsageStatsManager` [S-30] |
| Android steps | Health Connect via an Expo Module or a maintained community package [S-31] |
| iOS steps | HealthKit via an Expo Module or community package *(verify)* |
| iOS Screen Time | Not planned: data can't leave Apple's report extension [S-29] |

## Choices still open

| Question | Options | Notes |
|---|---|---|
| Sign-in (Q-13) | Email link/code, Apple, Google, phone OTP | ADR-007 |
| Data region | India (Mumbai) vs EU vs US | Choose for latency and law; record in an ADR |
| Analytics vendor | PostHog, Plausible-style, or none at MVP | Must not receive stat values |
| Live mode web join (Q-08) | Expo web vs a small separate web app | Later |
| Stay on Expo after the prototype? (Q-18) | Expo / two native apps with AI agents | See [benchmarks](industry-benchmarks.md#when-to-switch-to-native-review-at-the-end-of-the-prototype-q-18) |

## Cost notes *(Estimate, verify before committing)*

For the hand-run test: free. For the prototype and a small beta, the Supabase
and Expo free tiers are likely enough; check current limits for database size,
Edge Function invocations, Realtime connections and EAS builds before the beta.
Store accounts: Apple Developer Program (yearly fee) and Google Play (one-time fee).

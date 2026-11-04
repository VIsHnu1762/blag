---
id: adr.001
title: "ADR-001: Use React Native with Expo"
section: 07-architecture
status: proposal
summary: "ADR-001: Use React Native with Expo. Status: Proposed (from the team brief; confirm at kick-off)."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.home, stack.benchmarks]
---

# ADR-001: Use React Native with Expo

> **In short:** Build with React Native + Expo + TypeScript, using development builds (not Expo Go) once native modules are added, and EAS Build for store builds.

**Status:** Proposed (from the team brief; confirm at kick-off)

## Context

We need one app for Android and iOS, built by a small student team, with room for native modules later (Android usage stats, health data).

## Decision

Build with **React Native + Expo + TypeScript**, using **development builds** (not Expo Go) once native modules are added, and **EAS Build** for store builds. Target the current Expo SDK at kick-off (SDK 56 shipped React Native 0.85 in May 2026, and Expo recommends moving to SDK 57 for a known regression) [S-42].

## Options considered

| Option | For | Against |
|---|---|---|
| **Expo + React Native** | One TypeScript codebase; fast iteration; Expo Modules for native code; managed builds | Custom native code needs dev builds; some native APIs need our own modules |
| Flutter | Strong UI performance; one codebase | Team's existing skills are JavaScript; Supabase and Expo tooling fit better with TS |
| Fully native (Swift + Kotlin) | Best platform access | Two codebases; too slow for a small team |
| Bare React Native | Full control | More setup and upkeep than Expo for little gain |
| Two native apps built with AI coding agents | Shopify moved this way in Sep 2026 because agents cut the cost of building twice [S-61] | Needs Swift and Kotlin skill to review agent output; two release tracks; game engine still shared only on the server |
| Valdi (Snap) | TypeScript UI compiled to native views; proven inside Snapchat [S-47] | Still in beta as open source; small community |

## Consequences

Fast start and shared code with the backend's game engine (TypeScript). Review this decision at the end of the prototype phase (D-19, Q-18); see [industry benchmarks](../../08-tech-stack/industry-benchmarks.md). Native work (Android Usage Access, Health Connect, HealthKit) will need Expo Modules and development builds. Keep game logic out of UI components.

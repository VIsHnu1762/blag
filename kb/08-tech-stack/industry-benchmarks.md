---
id: stack.benchmarks
title: Industry benchmarks
section: 08-tech-stack
status: research
order: 1
summary: "What technology Snapchat, Duolingo, Wordle, BeReal, Discord, Bluesky, Instagram, Strava, Among Us and Shopify use for mobile and backend, the patterns across them, and what it means for BLAG's stack."
last_updated: 2026-11-04
audience: [developers, product, judges, agents]
related: [stack.home, adr.001, adr.002, idea.inspiration]
---

# Industry benchmarks

> **In short:** most big social apps build two native apps, but small and fast-moving teams (Discord, Bluesky, Shopify until 2026) did very well with React Native; Shopify's 2026 switch back to native shows AI coding tools are changing that trade-off, so BLAG keeps Expo for the MVP and reviews the choice after the prototype.

Status: **Research**. Stacks of private companies are known only from their
engineering blogs, job posts and open-source code. Treat every row as "publicly
visible signals", not a complete picture. Sources are in the
[sources register](../registers/sources.md).

## The table

| App | Why it's relevant to BLAG | iOS | Android | Shared / cross-platform layer | Backend and infrastructure | Sources |
|---|---|---|---|---|---|---|
| **Snapchat** | Close-friends social, streaks | Native (Swift, Objective-C) | Native (Kotlin, Java) | **Valdi**, Snap's own framework: UI written in TypeScript, compiled to native views; in production for 8 years, open-sourced in 2025 | Microservices on Google Cloud **and** AWS (moved off a Google App Engine monolith) | S-47, S-48 |
| **Duolingo** | Streaks, leagues, daily habit | Native (Swift) | Native (Kotlin) | TypeScript for web; **Rive** for character animation | Python and Kotlin services; Postgres and DynamoDB; AWS, Kubernetes, Terraform | S-49, S-50 |
| **Wordle (original)** | Daily ritual, viral share | Web only | Web only | Plain JavaScript and web components; no backend | Static files | S-51 |
| **Wordle / NYT Games** | Daily games at scale | NYT Games app hosts Wordle and Connections as **web apps** inside it; the new two-player Crossplay is a **native Swift** app | Same pattern | NYT rebuilt Wordle in React | NYT infrastructure (not public) | S-52 |
| **BeReal** | Daily prompt, close friends | Native (Swift, SwiftUI) | Native (Kotlin, Compose) | — | Go and Node.js (NestJS); Spanner, Postgres, Redis; Google Cloud, GKE, Firebase | S-56 |
| **Discord** | Friend groups, realtime | **React Native** since 2015 | **React Native** since 2022 | One React Native codebase, shared ideas with the React web app | Elixir for realtime messaging | S-53, S-54, S-65 |
| **Bluesky** | Young social network, small team | **React Native + Expo** | **React Native + Expo** | One codebase for iOS, Android **and web** | Go service for web; AT Protocol | S-55 |
| **Instagram** | Large social app | Native with **React Native** in parts | Native with **React Native** in parts | Mixed | Python and Django | S-57 |
| **Strava** | Social fitness, kudos | Native (Swift, Objective-C, C++) | Native *(not verified)* | — | Ruby on Rails and Scala microservices on AWS | S-58, S-64 |
| **Among Us** | Social deduction | **Unity** game engine | **Unity** | Same Unity project on mobile, PC and consoles | Unity Gaming Services for multiplayer | S-59 |
| **Shopify** (not social, but the key data point) | The best-documented React Native story | React Native 2020–2026, now **back to Swift** | React Native 2020–2026, now **back to Kotlin** | Said React Native "remains an excellent framework" | — | S-60, S-61, S-62 |

## Patterns

### 1. The biggest consumer apps mostly build two native apps
Snapchat, Duolingo and BeReal have separate native iOS and Android apps, and
Strava's iOS app is native [S-47, S-49, S-56, S-64]. They have large mobile teams and need the deepest
camera, media and performance work.

### 2. Even native companies want shared UI code
Snap built its own cross-platform layer (Valdi) and has used it in production
for eight years [S-47]. Instagram mixes in React Native [S-57]. Cross-platform
isn't a "beginner" choice; it's an efficiency choice.

### 3. Small, fast teams have thrived on React Native
Discord's iOS app was built with React Native from day one, and its Android
app moved to React Native in 2022 so both platforms ship together
[S-53, S-54]. Bluesky ships iOS, Android and web from one React Native + Expo
codebase [S-55].

### 4. The 2026 shift: AI agents make "build it twice" cheaper
On 10 September 2026 Shopify announced it is moving every mobile app from
React Native back to Swift and Kotlin. Its reason: coding agents have made
building the same feature twice cheap enough that a shared codebase no longer
pays for itself. Shopify also said its React Native apps were fast and the
framework remains excellent [S-61]. Analysts read this as the economics
changing, not React Native failing [S-62]. Shopify is also handing over or
archiving React Native libraries it maintained (React Native Skia, FlashList,
Restyle) [S-61].

### 5. Daily games can start very simple
The original Wordle was plain JavaScript with no backend [S-51]. Even inside the
NYT Games app, Wordle and Connections run as web apps; only the more complex
two-player game is native [S-52]. Simplicity didn't stop it becoming a global
ritual.

### 6. Real-time and social backends are boring and proven
Python, Go, Ruby, Scala, Elixir; Postgres and Redis; one or two big clouds
[S-48, S-49, S-56, S-58, S-65]. No one wins because of an exotic database.

### 7. Delight comes from animation tooling
Duolingo uses Rive state machines so characters react, blink and lip-sync
without shipping videos [S-50]. BLAG's reveal and stamp are its version of this.

### 8. Some features must be native whatever the framework
Home-screen widgets on iOS must be written in SwiftUI with WidgetKit, even in
React Native or Flutter apps [S-63]. The same applies to Screen Time
extensions and health integrations ([mobile dependencies](../09-mobile-dependencies/README.md)).

## What this means for BLAG

| Question | Answer for BLAG | Why |
|---|---|---|
| Native, React Native or Flutter? | **Expo + React Native for the MVP** (D-19, ADR-001) | Small student team; one TypeScript codebase shared with the game engine and Supabase; India is Android-heavy so both platforms matter from day one; BLAG's screens are simple (forms, cards, one animation) |
| Should we worry about Shopify leaving? | **Watch, don't panic** (R-15) | Their reason (AI makes two codebases cheap) applies most to big teams with native experts. Revisit after the prototype (Q-18) |
| Game engine like Unity? | **No** | Among Us needs real-time graphics; BLAG is a card-and-number game |
| Web-first like Wordle? | **Use it for the hand-run and demos, not the product** | BLAG needs push notifications, private Speaker notices and later native data; a web version of live mode is possible later (Q-08) |
| Backend | **Supabase (Postgres)** stays (ADR-002) | Same proven building blocks the big apps use, without running servers |
| Animation | **Start with Reanimated; prototype the stamp in Rive** (Q-19) | Rive powers Duolingo's characters and has a React Native runtime *(verify current support)* |
| Widgets and native data | **Expo Modules + native Swift/Kotlin where needed** | Widgets, Android usage access and health data need native code in any framework |

### When to switch to native (review at the end of the prototype, Q-18)

Move to two native apps (SwiftUI + Jetpack Compose) if **two or more** are true:
- The team has at least one confident Swift developer and one confident Kotlin developer.
- The team is comfortable building features with AI coding agents and reviewing their output.
- The prototype shows performance problems on mid-range Android phones that React Native can't fix.
- Native-only features (widgets, Screen Time views, health data) become core to the product.

Otherwise stay on Expo. The game engine (pure TypeScript) and the Supabase
backend carry over either way, because the server does all scoring (ADR-003).

## To do

- [ ] Find primary sources for Instagram's current React Native use (S-57 is secondary)
- [ ] Check Rive's current React Native and Expo support
- [ ] Look up stacks of Locket and Opal (not found in this pass)
- [ ] Re-check this page every six months; mobile stacks change fast

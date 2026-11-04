---
id: arch.learning
title: Learning guide to the code structure
section: 07-architecture
status: living
order: 7
summary: "Plain-language explanations, with everyday analogies, of every folder and engineering concept in BLAG's planned codebase: what it is, why enterprises use it, what goes wrong without it, and what to learn next, in the order you'll need them."
last_updated: 2026-11-04
audience: [everyone, developers]
related: [arch.repo, arch.services, arch.standards, arch.blueprint]
---

# Learning guide to the code structure

> **In short:** each idea below gets one plain sentence, an everyday analogy, how BLAG uses it, what breaks without it, and where to learn more; learn them in the order of the build phases at the bottom.

Think of BLAG's codebase as **a restaurant**: the app is the dining room, the
server is the kitchen, the database is the store room, and the rules of the
game are the recipe book everyone must follow. Most ideas below fit into that
picture.

## Part 1: The repository

### Monorepo
- **What:** one Git repository that holds the app, the server code, shared code and the docs.
- **Analogy:** one building with several rooms, instead of separate buildings across town.
- **In BLAG:** `apps/`, `packages/`, `supabase/`, `kb/` in one repo (ADR-008).
- **Without it:** the app and server drift apart; a rule fixed in one place stays broken in another.
- **Learn next:** [Expo: monorepos](https://docs.expo.dev/guides/monorepos/), [pnpm workspaces](https://pnpm.io/workspaces).

### `apps/` vs `packages/`
- **What:** `apps/` are things you ship to users; `packages/` are building blocks the apps share.
- **Analogy:** apps are the dishes served; packages are the shared sauces made once and used in many dishes.
- **In BLAG:** `apps/mobile`, `apps/web`; `packages/game-engine`, `contracts`, `config`.
- **Without it:** copy-pasted code that slowly becomes different in each copy.

### Package manager and workspaces (pnpm)
- **What:** the tool that downloads libraries and links your own packages together.
- **Analogy:** the supplier who stocks the kitchen and labels which shelf belongs to which cook.
- **Learn next:** [pnpm workspaces](https://pnpm.io/workspaces).

### Task runner with a cache (Turborepo)
- **What:** runs lint, tests and builds across all packages, and skips work whose inputs didn't change.
- **Analogy:** a chef who doesn't re-chop vegetables that are already chopped.
- **Without it:** CI gets slower every month.

### Strict TypeScript
- **What:** JavaScript with types; "strict" makes the compiler refuse risky code.
- **Analogy:** a recipe that says "200 g sugar", not "some sugar".
- **In BLAG:** shared `tsconfig.base.json`. The same types travel from database to app.
- **Learn next:** [TypeScript handbook](https://www.typescriptlang.org/docs/handbook/intro.html).

## Part 2: The app (`apps/mobile`)

### Routes folder (`src/app`)
- **What:** in Expo Router every file here is a screen with a URL; nothing else may live here.
- **Analogy:** the restaurant's floor plan: it says where tables are, not how food is cooked.
- **In BLAG:** thin route files that just show a feature's screen.
- **Learn next:** [Expo Router core concepts](https://docs.expo.dev/router/basics/core-concepts/).

### Feature folders with a front door (`src/features/<feature>/index.ts`)
- **What:** all code for one product feature in one folder; other code may only use what `index.ts` exports.
- **Analogy:** apartments with a front door: neighbours ring the bell, they don't climb in through the window.
- **In BLAG:** `circles/`, `round/`, `league/`, `finale/` … (ADR-009).
- **Without it:** changing one feature breaks three others you didn't know were connected.

### Design system (`src/ui/`, later `packages/tokens`)
- **What:** one set of buttons, cards, stamps and colours used everywhere.
- **Analogy:** the restaurant's plates and cutlery: every dish looks like it belongs.
- **In BLAG:** `Button`, `Stamp`, `NumberPad`; tokens from [visual identity](../05-brand/visual-identity.md).

### Infrastructure layer (`src/lib/`)
- **What:** code that talks to the outside world: Supabase, push, storage, analytics.
- **Analogy:** the waiter who carries orders between dining room and kitchen.
- **Without it:** network code scattered in screens; impossible to add retries or caching in one place.

### Server state vs screen state (TanStack Query)
- **What:** data from the server is cached and refreshed by a library; small UI state (which button is pressed) stays in the screen.
- **Analogy:** the menu board (server state, updated centrally) vs your own notepad (screen state).
- **Learn next:** [TanStack Query](https://tanstack.com/query/latest).

## Part 3: Shared packages

### Pure game engine (`packages/game-engine`)
- **What:** the rules as plain functions with no network, database or UI. Same input, same output, always.
- **Analogy:** the recipe book. The kitchen and the menu both follow it; nobody improvises.
- **In BLAG:** `truthZone()`, `scoreRound()`, `assignTitles()`; tested with every worked example in [scoring](../03-game-design/scoring.md).
- **Without it:** the app shows one score, the server stores another.

### Contracts (`packages/contracts`)
- **What:** the agreed shape of every request, response, error and event, checked at runtime with a schema library.
- **Analogy:** the order slip: the waiter and the kitchen both read the same form.
- **Learn next:** [Zod](https://zod.dev).

## Part 4: The backend (`supabase/`)

### Postgres and row-level security (RLS)
- **What:** the database, plus rules on every row that decide who may read or write it.
- **Analogy:** a store room where each shelf has its own guest list at the door.
- **In BLAG:** a member can read their circle's revealed rounds, never a seal ([data model](data-model.md)).
- **Learn next:** [Supabase row-level security](https://supabase.com/docs/guides/database/postgres/row-level-security).

### Migrations
- **What:** numbered SQL files that change the database step by step, applied in order everywhere.
- **Analogy:** numbered renovation permits: you can rebuild the same building anywhere by following them.
- **Without it:** your laptop's database and production's database quietly differ.

### Services as Edge Functions
- **What:** small server programs, one per business area, that receive the app's requests.
- **Analogy:** kitchen stations: grill, pastry, drinks. Each has its own job and its own fridge.
- **In BLAG:** identity, circles, game, league, scheduler, notifications, proofs ([service map](services.md)).

### Layers inside a service
- **What:** handler (reads the request) → use case (decides what to do) → domain (game engine rules) → data (database calls).
- **Analogy:** take the order → decide the steps → follow the recipe → fetch ingredients.
- **In BLAG:** [backend blueprint](backend-blueprint.md#inside-a-service).

### Idempotency keys
- **What:** a unique id sent with each action so repeating it has no extra effect.
- **Analogy:** a receipt number: the cashier won't charge you twice for the same receipt.
- **In BLAG:** every action; essential on patchy mobile networks.

### Events and queues
- **What:** a service announces "this happened"; others react in their own time, via a queue.
- **Analogy:** the office mail tray: you drop a note and carry on; the other department picks it up.
- **In BLAG:** `round.revealed` → League updates scores, Notifications sends pushes (Supabase Queues).
- **Without it:** services call each other directly and one slow service slows everyone.

### Scheduler (cron)
- **What:** a clock that triggers jobs at set times.
- **Analogy:** the restaurant's opening and closing bell.
- **In BLAG:** opens drops, applies cutoffs, triggers reveals every minute.

### Realtime channels
- **What:** a live connection so the app hears "something changed" instantly.
- **Analogy:** the kitchen bell that rings when a dish is ready; the waiter then fetches it.
- **In BLAG:** events carry only ids; the app then fetches data through access rules.

## Part 5: Shipping and running

### Environments and config
- **What:** separate copies for development, testing and real users; settings in environment variables, not code.
- **Analogy:** rehearsal stage vs opening night.
- **Learn next:** [The Twelve-Factor App: config](https://12factor.net/config).

### CI/CD
- **What:** robots that check every change (CI) and ship approved changes (CD).
- **Analogy:** a quality inspector at the kitchen door.

### Test pyramid
- **What:** many fast small tests, fewer bigger ones, a handful of full-journey tests.
- **Analogy:** taste each ingredient often, each dish sometimes, the whole menu before opening night.

### Conventional Commits and semantic versioning
- **What:** commit messages with a type (`feat`, `fix`) so tools can write release notes and pick the next version number.
- **Learn next:** [conventionalcommits.org](https://www.conventionalcommits.org), [semver.org](https://semver.org).

### ADRs
- **What:** short records of why a technical decision was made.
- **Analogy:** meeting minutes you'll thank yourself for in six months.

### Observability
- **What:** logs, metrics and alerts that tell you what the system is doing.
- **Analogy:** the dashboard in a car: speed, fuel, warning lights.

### Feature flags
- **What:** switches that turn a feature on or off without a new app release.
- **Analogy:** a dimmer switch instead of rewiring the room.

## Learning order (matches the roadmap)

| Phase | Learn | Why then |
|---|---|---|
| Before coding | TypeScript basics, Git, Conventional Commits | Everything builds on these |
| Prototype | Expo Router, feature folders, pure functions and unit tests, Supabase basics (tables, auth, RLS) | First playable round |
| MVP | Edge Functions and layers, migrations, contracts, idempotency, TanStack Query, scheduler, realtime | Real circles playing daily |
| Beta | Events and queues, environments, CI/CD, observability, feature flags | Running it for others |
| Later | Native modules in Swift and Kotlin, extracting a service | Widgets, auto-read, scale |

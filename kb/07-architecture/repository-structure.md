---
id: arch.repo
title: Repository structure
section: 07-architecture
status: proposal
order: 4
summary: "The full planned file structure for BLAG's code: a pnpm monorepo with the Expo app, shared packages (game engine, contracts, config) and Supabase, with dependency rules, naming conventions, a where-does-it-go table and a growth plan."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.home, arch.services, adr.008, adr.009, adr.010, stack.home, quality.home]
---

# Repository structure

> **In short:** one monorepo with an `apps/` folder (the Expo app now, a small web app later), a `packages/` folder for code shared across apps and the server (game engine, contracts, config), and `supabase/` for the database and server functions; features are self-contained folders with strict import rules, so the codebase can grow from one developer to a team without a rewrite.

Status: **Proposal** (ADR-008, ADR-009, ADR-010). Nothing here exists yet.
Create folders **only when the first file needs them** (see [growth plan](#growth-plan-create-folders-only-when-needed)).

How this measures up against enterprise practice is in the [enterprise standards scorecard](enterprise-standards.md); a plain-language tour of every part is in the [learning guide](learning-guide.md).

## Goals

| Goal | How the structure supports it |
|---|---|
| One person can start fast | Small number of top-level folders; Expo defaults kept |
| A team can join later | Feature folders with owners; clear rules on what may import what |
| Game rules are identical everywhere | One pure `game-engine` package used by the app and the server |
| The server stays the authority | All scoring and state live under `supabase/`; the app only sends intents (ADR-003) |
| New card types (movies, memes, music) plug in | Card types are modules behind one interface (P-38 to P-41) |
| AI agents can work safely | Predictable paths, a where-does-it-go table, `AGENTS.md` at the root |
| Optimisation later without restructuring | Caching, lazy routes, build caching and grouped server functions are planned in |

## Top level

```text
blag/
├── apps/
│   ├── mobile/                  # Expo + React Native app (iOS, Android)            ← MVP
│   └── web/                     # Small web app: account-deletion page, later live-mode web join   ← MVP (deletion page only)
├── packages/
│   ├── game-engine/             # Pure TypeScript game rules: truth zone, scoring, titles, Speaker choice  ← MVP
│   ├── contracts/               # Shared API types, validation schemas, error codes, realtime events     ← MVP
│   ├── db-types/                # Types generated from the database schema (never hand-edited)          ← MVP
│   ├── tokens/                  # Design tokens: colours, type, spacing (from kb/05-brand)               ← Next
│   ├── ui/                      # Shared design-system components, if a second app needs them            ← Later
│   └── config/                  # Shared tsconfig, ESLint and Prettier presets                            ← MVP
├── supabase/
│   ├── config.toml              # Local Supabase settings
│   ├── migrations/              # SQL schema and row-level-security changes, in order
│   ├── functions/               # Edge Functions (Deno), grouped by domain
│   ├── tests/                   # SQL tests for access rules (pgTAP)
│   └── seed.sql                 # Local test data (fake circles, never real people)
├── kb/                          # This knowledge base
├── scripts/                     # Repo tools: kb.py, codegen, release helpers
├── .github/                     # workflows (ci, e2e, deploy-backend, codeql, kb), CODEOWNERS, PR and issue templates, renovate.json
├── .changeset/                  # release notes and versions
├── AGENTS.md  CLAUDE.md  README.md  CONTRIBUTING.md  SECURITY.md  CHANGELOG.md  LICENSE
├── commitlint.config.js         # Conventional Commits check
├── package.json                 # Root: workspace scripts only, no app code
├── pnpm-workspace.yaml          # Declares apps/* and packages/*
├── turbo.json                   # Task graph and build cache (ADR-008)
├── tsconfig.base.json           # Strict TypeScript settings shared by all
├── .npmrc  .nvmrc  .editorconfig  .gitignore  .env.example
└── mkdocs.yml  requirements-docs.txt  llms.txt
```

Expo supports monorepos built with Bun, npm, pnpm or Yarn workspaces, and
configures its bundler for them automatically from SDK 52 onwards [S-67].

## `apps/mobile`

```text
apps/mobile/
├── app.config.ts                # App config per environment (dev, preview, production)
├── eas.json                     # EAS build and submit profiles
├── package.json
├── tsconfig.json                # Extends packages/config; "@/*" → src/*
├── assets/                      # Icons, splash, fonts, sounds, Rive/Lottie files
├── src/
│   ├── app/                     # ROUTES ONLY (Expo Router). Thin files that render feature screens
│   │   ├── _layout.tsx          # Root providers, fonts, error boundary
│   │   ├── (auth)/              # sign-in, age gate
│   │   ├── (onboarding)/        # welcome cards, lane and stats
│   │   ├── (main)/
│   │   │   ├── index.tsx        # Home: list of circles
│   │   │   ├── circle/[circleId]/
│   │   │   │   ├── index.tsx    # Today (the drop)
│   │   │   │   ├── seal.tsx  claim.tsx  read.tsx  reveal.tsx
│   │   │   │   ├── league.tsx
│   │   │   │   └── finale/[seasonId].tsx
│   │   │   ├── my-month.tsx
│   │   │   └── settings/        # notifications, stats, privacy, delete account
│   │   └── join/[code].tsx      # Invite deep link
│   ├── features/                # One folder per product feature (see anatomy below)
│   │   ├── auth/
│   │   ├── onboarding/
│   │   ├── circles/             # create, join, invite, leave
│   │   ├── consent/             # stats on/off, spicy and health confirmations, focus lane
│   │   ├── drop/                # today's state, catch-up card, rest day
│   │   ├── round/               # seal, claim, read, reveal, reactions
│   │   ├── league/
│   │   ├── finale/              # titles, moments, share card
│   │   ├── my-month/
│   │   ├── notifications/
│   │   └── account/             # settings, deletion
│   ├── cards/                   # Card-type UI plugins: stat (MVP), rest (MVP), movie/meme/music (later)
│   ├── ui/                      # App design system: Button, Card, Stamp, NumberPad, Avatar, Sheet
│   ├── lib/                     # Infrastructure, no product logic
│   │   ├── supabase/            # Client, auth session, typed queries
│   │   ├── api/                 # Calls to Edge Functions with idempotency keys
│   │   ├── query/               # TanStack Query client, cache keys
│   │   ├── realtime/            # Circle channel subscription
│   │   ├── offline/             # Action queue for poor connections
│   │   ├── analytics/           # Wrapper that blocks stat values by design
│   │   ├── logging/             # Crash reporting with scrubbing
│   │   └── storage/             # SecureStore and local storage helpers
│   ├── i18n/                    # String catalogues (en first), number formatting
│   ├── theme/                   # Reads tokens; light and dark themes
│   └── config/                  # Typed environment and feature flags
├── modules/                     # Local native modules (Expo Modules), added only when needed
│   ├── today-widget/            # iOS WidgetKit (Swift) + Android widget (Kotlin)    ← Later
│   └── android-usage/           # UsageStatsManager reader (Kotlin)                   ← Later
└── e2e/                         # Maestro end-to-end flows
```

In Expo Router, the `src/app` folder is only for routes: any other file placed
there is treated as a screen. Components, hooks and the rest live elsewhere in
`src/` [S-68].

### Feature folder anatomy

Every feature follows the same shape, so people and agents always know where to look:

```text
features/round/
├── index.ts                 # PUBLIC API: the only file other code may import
├── screens/                 # Full screens used by routes in src/app
│   ├── SealScreen.tsx
│   └── RevealScreen.tsx
├── components/              # Pieces used only inside this feature
│   └── TruthZoneHint.tsx
├── hooks/                   # useRound(), useSubmitRead() …
├── api.ts                   # Queries and mutations for this feature (uses lib/api, lib/query)
├── state.ts                 # Local UI state if needed
├── copy.ts                  # Keys into the i18n catalogue for this feature
└── __tests__/               # Component and hook tests
```

Rules: a feature never imports another feature's internals, only its `index.ts`.
Shared logic moves down into `ui/`, `lib/` or a package.

## `packages/`

```text
packages/game-engine/
├── src/
│   ├── truth-zone.ts            # truthZone(), isTruth()
│   ├── scoring.ts               # scoreRound()
│   ├── season.ts                # seasonScore() (best 20)
│   ├── titles.ts                # assignTitles()
│   ├── speaker.ts               # pickSpeaker(), pickStat()
│   ├── state-machine.ts         # allowed transitions per drop state
│   ├── cards/                   # Card-type rules: stat.ts, rest.ts (one interface for all)
│   ├── catalog/stats.ts         # Generated from kb/data/stats.yaml
│   └── index.ts
├── test/                        # Unit tests from every worked example in kb/03-game-design
└── package.json                 # No runtime dependencies. No React, no Supabase, no I/O

packages/contracts/
├── src/
│   ├── actions/                 # Request and response shapes for each server action
│   ├── events.ts                # Realtime event names and payloads (ids only)
│   ├── errors.ts                # Error codes shared by app and server
│   └── index.ts
└── package.json                 # Depends only on a schema library (e.g. zod)

packages/db-types/               # Output of `supabase gen types`; regenerated in CI
packages/config/                 # tsconfig presets, ESLint config, Prettier config
packages/tokens/                 # Design tokens as TypeScript (and later JSON for Figma)
```

The game engine is the most important package: it's where the rules in
[game design](../03-game-design/README.md) become code, tested once and used by
both the app (for instant previews such as the truth zone) and the server (for
the real result).

## `supabase/`

```text
supabase/
├── config.toml
├── migrations/
│   ├── 20261110000000_core_schema.sql
│   ├── 20261110000100_rls_policies.sql
│   └── …                         # One change per file, never edited after merge
├── functions/                   # One folder per service (see the service map)
│   ├── _shared/                 # Auth check, errors, idempotency, db client, rate limits, event outbox
│   ├── identity/                # profile, device registration, account deletion
│   ├── circles/                 # create, join, leave, invite-reset, lane-set, consent-set
│   ├── game/                    # seal, claim, pass, read, react (uses packages/game-engine)
│   ├── league/                  # day scores, season close, titles (uses packages/game-engine)
│   ├── scheduler/               # drops-tick, season-tick (called by pg_cron)
│   ├── notifications/           # reads the event queue, sends pushes
│   ├── proofs/                  # upload and view URLs for screenshot proofs
│   └── deno.json                # Imports, including the shared packages
├── tests/
│   ├── rls_seals.test.sql       # "A member can't read private.seals" …
│   └── rls_reads.test.sql
└── seed.sql
```

Supabase recommends keeping shared function code in a folder whose name starts
with an underscore, and building a few larger functions that combine related
actions to reduce cold starts [S-69]. Inside each service the code is layered (handler → use case → domain → data); see the [backend blueprint](backend-blueprint.md#inside-a-service). BLAG follows that: each **service** from the [service map](services.md) is
one function folder, and each action from [API and realtime](api-and-realtime.md)
is a route inside it (ADR-010). Services talk to each other through events on a
queue, never by writing each other's tables. Importing code from outside `supabase/` (our
`packages/`) is supported for monorepos [S-70] *(verify the current deploy
command when setting up)*.

## Dependency rules

```mermaid
flowchart TD
    ROUTES["apps/mobile/src/app (routes)"] --> FEAT["features/*"]
    FEAT --> CARDS["cards/*"]
    FEAT --> UI["ui/"]
    FEAT --> LIB["lib/"]
    CARDS --> UI
    UI --> THEME["theme/ + packages/tokens"]
    LIB --> CONTRACTS["packages/contracts"]
    FEAT --> ENGINE["packages/game-engine"]
    FUNCS["supabase/functions"] --> ENGINE
    FUNCS --> CONTRACTS
    LIB --> DBT["packages/db-types"]
    FUNCS --> DBT
```

| Rule | Why |
|---|---|
| Arrows only point down. Nothing imports "upwards" | Prevents tangles as the app grows |
| `game-engine` imports nothing except the standard library | Rules stay pure and identical on app and server |
| Features import other features only through their `index.ts` | Each feature can change internally without breaking others |
| `src/app` files contain no logic; they render a feature screen | Routes can be reorganised freely |
| Only `lib/supabase` talks to Supabase directly | One place to change auth, retries and caching |
| Nothing in the app imports from `supabase/functions` | The server is a separate deployment |

Enforced in CI with an import-boundary lint rule (for example
`eslint-plugin-boundaries` or `dependency-cruiser`) *(Proposal, ADR-009)*.

## Naming conventions

| Thing | Convention | Example |
|---|---|---|
| Folders | kebab-case | `my-month/`, `truth-zone.ts` |
| React components and screens | PascalCase file and export | `RevealScreen.tsx` |
| Hooks | `use` + camelCase | `useSubmitRead.ts` |
| Pure functions | camelCase verbs | `scoreRound()` |
| Tests | Same name + `.test.ts(x)` | `scoring.test.ts` |
| Routes | Lowercase, glossary words | `circle/[circleId]/reveal.tsx` |
| Database | snake_case, glossary code names | `circle_members`, `reveal_at` |
| Edge Function routes | kebab-case verbs | `game/claim` |
| Environment variables | `EXPO_PUBLIC_` prefix only for values safe to ship in the app | `EXPO_PUBLIC_SUPABASE_URL` |
| Packages | `@blag/` scope | `@blag/game-engine` |

Use the [glossary](../00-start-here/glossary.md) words in code: `circle`,
`drop`, `round`, `seal`, `claim`, `read`, `reveal`, `season`, `speaker`.

## Environments

| Environment | Supabase | App build | Used for |
|---|---|---|---|
| `local` | `supabase start` on your machine | Expo dev client | Daily development |
| `preview` | Separate Supabase project | EAS "preview" profile, internal distribution | Testers and the beta |
| `production` | Separate Supabase project | EAS "production" profile, stores | Real users |

Secrets (service-role key, push credentials) live only in Supabase and EAS
secret stores, never in the repo. `.env.example` lists every variable with a
fake value.

## Where does it go?

| I want to add… | Put it in |
|---|---|
| A new screen | Route file in `apps/mobile/src/app/…` + screen in `features/<feature>/screens/` |
| A rule about points, truth or titles | `packages/game-engine` + a test, then update `kb/03-game-design` |
| A new server action | Route in the owning service's `supabase/functions/<service>/` + shapes in `packages/contracts` |
| Something one service must tell another | An event in `packages/contracts/src/events.ts`, written to the outbox, handled idempotently |
| A database table or policy | New file in `supabase/migrations/` + test in `supabase/tests/` + update [data model](data-model.md) |
| A new card type (e.g. movie) | Rules in `packages/game-engine/src/cards/`, UI in `apps/mobile/src/cards/` |
| A reusable button or stamp | `apps/mobile/src/ui/` (move to `packages/ui` only if a second app needs it) |
| A colour or font size | `packages/tokens` |
| User-facing text | `apps/mobile/src/i18n/` catalogue, checked against [voice and tone](../05-brand/voice-and-tone.md) |
| A native iOS or Android feature | `apps/mobile/modules/<name>/` as an Expo Module |
| A scheduled job | `supabase/functions/scheduler/` + a `pg_cron` entry in a migration |
| An end-to-end test | `apps/mobile/e2e/` |
| A decision | `kb/data/decisions.yaml`, or an ADR for technical ones |

## Built-in room to optimise later

| Area | Planned now | Turn on when |
|---|---|---|
| Build speed | Turborepo task cache | From day one; add remote cache when CI gets slow |
| App start time | Thin routes; heavy screens (finale, my month) loaded lazily | If cold start on a mid-range Android exceeds about 2 s |
| Lists | One list component wrapper in `ui/` | Swap the implementation without touching features |
| Network | TanStack Query cache, ids-only realtime events | Always on |
| Offline | `lib/offline` action queue with idempotency keys | MVP |
| Server cold starts | One function per service, not per action (ADR-010) | Always on |
| Hot service | Service boundaries with events | Extract that service into its own microservice ([service map](services.md#when-to-extract-a-service-into-its-own-microservice)) |
| Database | Indexes on `circle_id`, `season_id`, `local_date`, `round_id` | In the first migration |
| Updates | EAS Update channels per environment | For copy and bug fixes without store review (within store rules) |
| Native speed-ups | `modules/` for hot paths in Swift or Kotlin | Only if profiling shows a need |

## Growth plan: create folders only when needed

| Phase ([roadmap](../12-roadmap/README.md)) | What exists |
|---|---|
| 2. Prototype | `apps/mobile` (auth, circles, round, a basic league), `packages/game-engine`, `packages/contracts`, `packages/config`, `supabase/` with `game` and `scheduler` services |
| 3. MVP | All MVP features, `apps/web` with the deletion page, `packages/db-types`, the remaining services (identity, circles, league, notifications, proofs), the event queue, e2e flows, CI |
| 4. Beta | `packages/tokens`, analytics and crash reporting in `lib/`, preview environment |
| Later | `modules/today-widget`, `modules/android-usage`, new card types, `packages/ui` if a second app shares components |

## Open questions

- Package manager: pnpm (lean) or Bun. Expo supports both; isolated installs work from SDK 54, but some React Native libraries may still break with them [S-67]. Start pnpm with hoisted installs and revisit.
- Exact deploy command for Edge Functions importing `packages/` [S-70].

# Tech stack

Status: **Seeded**. Last updated: 2026-11-04. Nothing here is decided yet.

## Current proposal (from the original spec and master prompt)

| Layer | Proposal | Why it was proposed |
|---|---|---|
| Mobile | React Native with Expo and TypeScript | One codebase for Android and iOS; fast for a small student team |
| Native code | Expo development builds, with Kotlin (Android) and Swift (iOS) modules where needed | Expo Go can't run custom native modules |
| Backend | Supabase: Auth, Postgres, Realtime, Edge Functions, row-level security | Few moving parts; realtime and auth included |
| Builds | EAS Build | Fits Expo |
| Notifications | Expo push notifications | Fits Expo |

## Questions this section must answer

- [ ] Validate Expo vs bare React Native vs Flutter vs fully native, given the
      [mobile dependency findings](../mobile-dependencies/README.md)
- [ ] Does Supabase handle sealed values and scheduled daily drops well (cron, Edge Functions)?
- [ ] How does a live mode with a web join fit (Q-08)?
- [ ] Analytics and crash reporting that respect the privacy principles
- [ ] Hosting region and data residency for India and the EU
- [ ] Cost at hand-run, beta and launch scale
- [ ] Testing tools for game logic, database rules and end-to-end flows

Record each decision as an ADR in the [architecture section](../architecture/README.md).

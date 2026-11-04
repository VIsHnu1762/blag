---
id: mobile.home
title: Mobile dependencies
section: 09-mobile-dependencies
status: research
summary: "What iOS and Android actually allow for screen time, app usage and health data, with confidence levels, sources and consequences for BLAG."
last_updated: 2026-11-04
audience: [developers, product, judges, agents]
related: [mobile.permissions, game.stats, adr.004, privacy.compliance]
---

# Mobile dependencies

> **In short:** on iPhone, apps can't export Screen Time numbers, so iPhone players type them in; Android can read usage with a special permission; health data needs extra permissions and store review on both.

Platform rules change. **Re-check every row before relying on it** and update
`checked` dates in `kb/data/sources.yaml`.

## Summary

| Data | iPhone | Android | BLAG plan |
|---|---|---|---|
| Total screen time | Shown in Settings; **can't be exported** by apps | Readable with Usage Access | Manual on both (MVP); Android auto-read later |
| Per-app time | Same as above | Readable with Usage Access | Same |
| Pickups / unlocks | Shown in Settings; not exportable | Possibly derivable from usage events *(verify)* | Manual |
| Late-night use | Hourly chart in Settings; not exportable | Derivable from usage events with Usage Access | Manual; Android later |
| Steps | HealthKit with permission *(verify)* | Health Connect with permission and Play declaration | Manual (MVP); health APIs later |
| Sleep | HealthKit if tracked *(verify)* | Health Connect if tracked | Manual, Next |

## iOS: Screen Time

| Finding | Confidence | Source |
|---|---|---|
| Screen Time data is available to third-party apps only inside a sandboxed **DeviceActivityReport** extension | High | [S-29] |
| That sandbox blocks network requests and moving data out of the extension, even to the app's own shared storage | High | [S-29] |
| There is no public API to read total or per-app screen time into the app itself | High | [S-29] |
| Shipping any Screen Time API needs the **Family Controls (Distribution)** entitlement, requested from Apple for the app and **each extension** | High | [S-39] |
| Developers in 2026 report waiting weeks for that entitlement | Medium | [S-40] |

**Consequence:** BLAG can't send an iPhone user's screen time to their circle.
At most, it could show the user their own numbers privately inside the
extension, which needs the entitlement (Q-15). The MVP uses manual entry
(ADR-004) and seals the value (P-14).

## Android: app usage

| Finding | Confidence | Source |
|---|---|---|
| `UsageStatsManager` provides app usage aggregated by day, week, month or year | High | [S-30] |
| Most methods need `PACKAGE_USAGE_STATS`, which the user grants on the system **Usage access** settings screen, not a normal pop-up | High | [S-30] |
| Google Play restricts certain sensitive permissions and may require a declaration form | Medium | [S-45] |
| Whether Usage Access specifically needs a declaration for BLAG's use | Unknown | Q-16 |
| Some manufacturers change where the Usage access screen lives | Low | Needs device testing |

**Consequence:** Android auto-read is possible but must be optional, explained
clearly before sending the user to Settings, and checked against Play policy.

## Health data

| Finding | Confidence | Source |
|---|---|---|
| Android Health Connect gives per-data-type permissions; it's part of Android 14+ and an app on older versions | High | [S-31] |
| Data types used must be declared in the Play Console, and access is reviewed | Medium | [S-31] |
| HealthKit provides steps with user permission on iPhone | Medium | To verify in Apple docs |
| Steps and sleep may count as health data under privacy law | Medium | Q-04, [S-41] |

## Store requirements that affect the app

| Requirement | Source |
|---|---|
| iOS: apps that let people create accounts must let them start account deletion inside the app | [S-38] |
| Google Play: apps with accounts must offer deletion in the app **and** a web link where users can request deletion | [S-37] |
| Google Play: the Data safety form must accurately declare collected data | [S-45] |

## To do

- [ ] Read Apple's DeviceActivity and FamilyControls documentation directly and note the exact wording
- [ ] Decide Q-15 (request the Family Controls entitlement or not)
- [ ] Check Google Play policy for Usage Access (Q-16)
- [ ] Test the Usage access flow on 3–5 Android brands
- [ ] Check HealthKit and Health Connect policies for a game, not a health app
- [ ] Verify whether Android usage events can give pickups and late-night minutes reliably

See also: [permissions](permissions.md).

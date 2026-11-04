# Mobile dependencies

Status: **Seeded, first research done**. Last updated: 2026-11-04.
Platform rules change. Re-check every finding before relying on it.

This section records what iOS and Android actually allow. It matters more than
any other technical question, because BLAG's reveal depends on getting real
numbers.

## First findings

### iOS: Screen Time

| Finding | Confidence | Source |
|---|---|---|
| Screen Time data is only available inside a sandboxed **DeviceActivityReport** extension | High | Apple developer forum answers [S-29] |
| That sandbox **blocks network requests and blocks moving the data out**, even to the app's own shared storage | High | Apple developer forum answers [S-29] |
| There is **no public API** to read total screen time or per-app time into the app | High | Apple developer forum answers [S-29] |
| Using the Screen Time frameworks needs the **Family Controls entitlement**, which Apple approves | Medium | Original spec; confirm in Apple docs |

**What this means:** on iPhone, BLAG can probably *display* a player's screen
time to that player inside the extension, but it can't send the number to
friends or the server. So **iPhone stats will be typed in by the player.**
This is risk R-01. The game design (seal before you claim, trust tiers)
already assumes it.

### Android: app usage

| Finding | Confidence | Source |
|---|---|---|
| **UsageStatsManager** gives per-app usage aggregated by day, week, month or year | High | Android developer docs [S-30] |
| It needs **PACKAGE_USAGE_STATS**, which the user grants on a system "Usage access" settings screen, not a normal pop-up | High | Android developer docs [S-30] |
| Some manufacturers may change or hide that settings screen | Low | Older Stack Overflow reports; needs device testing |
| Google Play may restrict how apps use this permission | Unknown | Needs a policy check |

**What this means:** on Android, BLAG could read usage automatically with
permission. That creates an uneven playing field between Android and iPhone
players, which the trust-tier idea (P-15) has to handle fairly.

### Steps and health data

| Finding | Confidence | Source |
|---|---|---|
| Android **Health Connect** provides steps with per-type permissions; it's built into Android 14+ and an app on older versions | High | Android developer docs [S-31] |
| Apps using Health Connect must declare the data types they access in the Play Console, and Google reviews access | Medium | Android docs and integrator documentation [S-31] |
| iOS **HealthKit** can provide steps with permission | Medium | To be checked in Apple docs |

## To do in this section

- [ ] Read Apple's DeviceActivity and FamilyControls documentation directly
- [ ] Check the Family Controls entitlement process and whether BLAG's use case qualifies
- [ ] Check Google Play's policy on usage-access permission
- [ ] Check HealthKit and Health Connect policies for a game (not a health app)
- [ ] Test the Android usage-access flow on 3–5 real devices from different brands
- [ ] Define how late-night use and pickups could be measured on Android, if at all
- [ ] Decide what counts as a "trusted" number on each platform
- [ ] List every permission BLAG would ask for, with the reason shown to users

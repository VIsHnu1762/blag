---
id: mobile.permissions
title: Permissions
section: 09-mobile-dependencies
status: proposal
summary: "Every device permission BLAG might ask for, when it's asked, the explanation shown, and the fallback if refused."
last_updated: 2026-11-04
audience: [developers, design, agents]
related: [mobile.home, privacy.inventory, brand.voice]
---

# Permissions

> **In short:** the MVP asks only for notifications (and photos, only if someone attaches a screenshot); everything else is later and optional.

## Rules

1. Ask **in context**, at the moment the feature is used, never at sign-up.
2. Show BLAG's own explanation screen first, then the system prompt.
3. Every permission has a **fallback**: refusing never blocks playing.
4. No contacts permission in the MVP (D-07).

In the MVP BLAG requests **no** health, usage-access or Screen Time permissions: every stat is typed in (D-34, D-39). The rows marked Later below are the plan for after the MVP.

## Permission list

| Permission | Platform | Release | Asked when | BLAG explanation (draft) | If refused |
|---|---|---|---|---|---|
| Notifications | Both | MVP | After joining the first circle | "We'll tell you when you're the Speaker and when the truth is out. Max 3 a day." | Play by opening the app |
| Photos (pick one image) | Both | MVP | Speaker taps "Add screenshot" | "Pick the screenshot you want to attach. We only see that one image." | Seal without proof |
| Usage Access (`PACKAGE_USAGE_STATS`) | Android | Later | Member taps "Fill this in for me" on the seal screen | "BLAG can read your app usage on this phone so you don't have to type it. You can still edit it. Only the number you seal is sent." | Type the number |
| Health Connect: steps | Android | Later | Same, for steps | "BLAG can read yesterday's steps from Health Connect. Only the number you seal is sent." | Type the number |
| HealthKit: steps | iOS | Later | Same, for steps | Same wording | Type the number |
| Contacts | Both | Later (P-36) | Never automatically; only if contact sync is built | To be written with privacy review | Invite links |

On iOS, picking a single photo through the system picker may not need full
photo library access *(verify on current iOS)*.

## Data minimisation for auto-read (later)

When auto-read exists, the app reads usage **on the device**, computes only the
one number for today's topic, shows it to the member, and sends nothing until
they seal. No usage history leaves the phone ([data inventory](../10-privacy-security/data-inventory.md)).

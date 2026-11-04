---
id: adr.007
title: "ADR-007: Sign-in method"
section: 07-architecture
status: proposal
summary: "ADR-007: Sign-in method. Status: Proposed (Q-13 open)."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.home]
---

# ADR-007: Sign-in method

> **In short:** Not decided.

**Status:** Proposed (Q-13 open)

## Context

Members must be able to sign in easily and recover their account; stores have rules for sign-in and account deletion [S-38, S-37].

## Decision

Not decided. Leading option: **email one-time link or code** plus **Sign in with Apple** and **Google**, with no phone-number requirement. Check the current App Store rules on offering Sign in with Apple alongside other social logins before deciding.

## Options considered

| Option | For | Against |
|---|---|---|
| Phone OTP | Familiar in India | SMS costs; phone numbers are sensitive; SIM changes |
| Email link/code | Cheap; no password | Slower first sign-in |
| Apple / Google sign-in | One tap | Store rules to check; platform lock-in for some users |

## Consequences

Whatever is chosen, account deletion must be available in the app and on the web (F-18).

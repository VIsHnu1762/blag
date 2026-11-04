---
id: adr.007
title: "ADR-007: Sign-in method"
section: 07-architecture
status: agreed
summary: "ADR-007: Sign-in method. Status: Accepted (D-26)."
last_updated: 2026-11-04
audience: [developers, agents]
related: [arch.adr, arch.home]
---

# ADR-007: Sign-in method

> **In short:** Email one-time code, Google, and Sign in with Apple on iPhone; phone numbers after the MVP.

**Status:** Accepted (D-26, 2026-11-04)

## Context

Members must be able to sign in easily and recover their account; stores have rules for sign-in and account deletion [S-38, S-37].

## Decision

- **Email one-time code** (Supabase Auth), **Google**, and **Sign in with Apple** on iPhone, shown with equal prominence.
- Apple guideline 4.8 requires an equivalent privacy-focused login whenever Google or another social login sets up the main account; Sign in with Apple is the option known to satisfy it [S-77, S-78].
- **Phone-number sign-in comes after the MVP**: every text message costs money, and business SMS in India needs sender registration.
- Age: 18+ self-attestation at sign-up; the date of birth is not stored (D-27).

## Options considered

| Option | For | Against |
|---|---|---|
| Phone OTP | Familiar in India | SMS costs; phone numbers are sensitive; SIM changes |
| Email link/code | Cheap; no password | Slower first sign-in |
| Apple / Google sign-in | One tap | Google requires Apple as well on iOS [S-77] |

## Consequences

Whatever is chosen, account deletion must be available in the app and on the web (F-18).

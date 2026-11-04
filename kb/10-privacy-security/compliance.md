---
id: privacy.compliance
title: Compliance map
section: 10-privacy-security
status: research
summary: "Laws, store rules and standards relevant to BLAG (DPDP, GDPR, CCPA, Apple and Google rules, WCAG, OWASP MASVS, ISO documentation standards) and what each requires."
order: 3
last_updated: 2026-11-04
audience: [product, developers, judges]
related: [privacy.home, privacy.inventory, mobile.home]
---

# Compliance map

> **In short:** BLAG aims to align with these rules and standards (not to be certified); the biggest practical items are age, consent, account deletion and accessibility.

**Not legal advice.** Get a qualified review before launch. Decision D-12: claim
alignment, never certification. The earlier
[decisions workbook](../registers/design-decisions-2026-11-01.xlsx) has the first version of this list.

## Privacy law

| Law | Applies when | What it means for BLAG | Source |
|---|---|---|---|
| **India: DPDP Act 2023 and DPDP Rules 2025** | Users in India (first market) | Rules notified on 13 Nov 2025, with obligations phased in on dates in Nov 2025, Nov 2026 and May 2027. Anyone under 18 is a child needing verifiable parental consent, which is a strong reason to launch 18+ (Q-03). Breaches must be reported to the Data Protection Board within 72 hours | [S-41], [S-46] |
| EU GDPR / UK GDPR | Users in the EU or UK | Lawful basis and consent; health data is special category data, so steps and sleep need explicit consent; access and erasure rights | General knowledge; verify |
| **BLAG's health-data rule (D-39)** | Everywhere | DPDP has no separate sensitive category [S-81], but BLAG applies the GDPR standard to steps and sleep: separate opt-in per health stat, never in analytics, number deleted at the reveal; typed in, no HealthKit or Health Connect in the MVP | [S-81] |
| US: California CCPA/CPRA | California users at scale | Notice, deletion and access rights | General knowledge; verify |

## Store rules

| Rule | What it requires | Source |
|---|---|---|
| Apple guideline 5.1.1(v) | Apps with account creation must let people start account deletion inside the app | [S-38] |
| Apple guideline 4.8 | Offering Google sign-in means also offering an equivalent privacy-focused login; Sign in with Apple satisfies it (D-26) | [S-77], [S-78] |
| Apple guideline 1.2 | User content needs a filter, a report mechanism with timely response, blocking, and terms with zero tolerance; BLAG keeps free text to names (D-42, F-24) | [S-79], [S-80] |
| Google Play account deletion | In-app deletion path **and** a web link for deletion requests, declared in the Data safety form | [S-37] |
| Google Play sensitive permissions | Some permissions need a declaration and approval; check Usage Access (Q-16) | [S-45] |
| Google Play Health Connect | Declare health data types and pass review | [S-31] |
| Apple Family Controls | Distribution entitlement needed for any Screen Time API use | [S-39] |
| Apple and Google privacy labels | Accurate declaration of collected data | [S-45] |

## Standards

| Standard | Use in BLAG |
|---|---|
| WCAG 2.2 AA | Accessibility target ([accessibility](../06-design/accessibility.md)) |
| EN 301 549 | EU accessibility reference for ICT; met largely through WCAG |
| OWASP MASVS | Mobile security checklist ([threat model](threat-model.md)) |
| ISO/IEC 29100 | Privacy framework terms for the privacy pages |
| ISO/IEC 27001 | Reference for security practices (no certification planned) |
| ISO 9241-210 | Human-centred design process ([research plan](../02-users/research-plan.md)) |
| ISO/IEC/IEEE 29148 | Requirements structure (feature catalogue, user stories) |
| ISO/IEC/IEEE 42010 | Architecture description (architecture section, ADRs) |
| ISO/IEC/IEEE 29119 | Testing structure ([quality](../11-quality/README.md)) |

## Pre-launch compliance checklist

- [ ] Legal review of age policy (D-27) and health data (D-39)
- [ ] Terms of use with the zero-tolerance line; Report, Block and contact email live (F-24)
- [ ] Sign in with Apple shown with equal prominence on iPhone (D-26)
- [ ] Name and trademark check for BLAG in India and the main store markets
- [ ] Grievance contact published (DPDP)
- [ ] Support page and age-rating questionnaires (Apple, Google) done
- [ ] Privacy policy written from the [data inventory](data-inventory.md)
- [ ] In-app and web account deletion live (F-18)
- [ ] Apple privacy label and Google Data safety form completed
- [ ] Breach response plan with the 72-hour notice step
- [ ] WCAG 2.2 AA review of MVP screens

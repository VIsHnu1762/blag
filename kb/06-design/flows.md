---
id: design.flows
title: Flows
section: 06-design
status: draft
summary: "Diagrams of the main user flows: onboarding and joining, a Speaker's turn, a reader's turn, and leaving or deleting."
order: 3
last_updated: 2026-11-04
audience: [design, developers]
related: [design.screens, users.journeys, game.state]
---

# Flows

> **In short:** four diagrams covering how people get in, speak, read and leave; screen ids match the [screen inventory](screens.md).

## Onboarding and joining

```mermaid
flowchart TD
    A[Invite link or QR] --> B{Has the app?}
    B -- No --> C[Store page] --> D[S1 Welcome]
    B -- Yes --> E{Signed in?}
    D --> F[S2 Sign up + 18+ check]
    E -- No --> F
    E -- Yes --> G[S6 Join circle]
    F --> G
    G --> H[S7 Pick lane and stats]
    H --> I[S8 Today]
```

## Speaker's turn

```mermaid
flowchart TD
    N1[Notification: you're the secret Speaker] --> T[S8 Today, private view]
    T --> P{Play or pass?}
    P -- Pass --> X[Backup chosen privately; nobody is told]
    P -- Play --> S[S9 Seal real number]
    S --> Z[S10 See truth zone, make claim]
    Z --> C[Claim published with name]
    C --> W[Wait for reveal]
    W --> R[S12 Reveal and points]
```

## Reader's turn

```mermaid
flowchart TD
    N2[Notification: claim made] --> T2[S8 Today shows claim]
    T2 --> RD[S11 Read TRUE or BLUFF, optional guess]
    RD --> L[Locked in; can change until reveal]
    L --> Q{Everyone read?}
    Q -- Yes --> R2[S12 Early reveal]
    Q -- No --> TM[Reveal at reveal time] --> R2
```

## Leaving and deleting

```mermaid
flowchart TD
    ST[S16 Settings] --> LV[Leave circle] --> CF1[One confirmation] --> OUT[Removed from future drops]
    ST --> DEL[Delete account] --> EXP[Explain what will be deleted] --> CF2[Confirm] --> GONE[Data deleted; past rounds show 'a former member']
    WEB[Web deletion page] --> CF2
```

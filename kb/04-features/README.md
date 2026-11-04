---
id: features.home
title: Features
section: 04-features
status: draft
summary: "How ideas become features: the MVP scope, user stories, notifications, and the generated feature catalogue with acceptance criteria."
last_updated: 2026-11-04
audience: [product, developers, agents]
related: [registers.features, features.mvp, features.stories, features.notifications]
---

# Features

> **In short:** ideas live in the idea bank; the ones we commit to building become features (F-ids) with acceptance criteria.

| Page | What it covers |
|---|---|
| [Feature catalogue](../registers/features.md) | Every feature by release, with acceptance criteria (generated from `kb/data/features.yaml`) |
| [MVP scope](mvp-scope.md) | What's in and out of the first playable version, and why |
| [User stories](user-stories.md) | The MVP as user stories grouped into epics |
| [Notifications](notifications.md) | Every notification, its wording and its rules |

## How an idea becomes a feature

1. The idea is in the [idea bank](../registers/ideas.md) with a `P-` id.
2. The team agrees to build it: a decision is logged.
3. It gets an `F-` id in `kb/data/features.yaml`, with `ideas: [P-..]`, a release and acceptance criteria.
4. Each acceptance criterion becomes at least one test ([quality](../11-quality/README.md)).
5. Every feature is checked against the [red lines](../01-idea/05-principles-and-red-lines.md) before it's agreed.

## Prioritisation

Features use **MoSCoW** within a release: Must, Should, Could, Won't (this
release). Releases are `MVP`, `Next`, `Later` ([roadmap](../12-roadmap/README.md)).

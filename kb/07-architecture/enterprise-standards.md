---
id: arch.standards
title: Enterprise standards scorecard
section: 07-architecture
status: proposal
order: 6
summary: "Checks BLAG's planned code structure against recognised enterprise practices (architecture, code quality, testing, security, operations, data, documentation), lists the gaps found and how they're closed, and keeps it right-sized for a solo founder."
last_updated: 2026-11-04
audience: [developers, agents, judges]
related: [arch.repo, arch.services, arch.learning, quality.home, privacy.threats]
---

# Enterprise standards scorecard

> **In short:** the planned structure already meets most enterprise practices (layered architecture, service boundaries, ADRs, strict types, tests, access rules); this page closes the remaining gaps (commit conventions, versioning, code owners, dependency updates, security scanning, runbooks, service-level targets) and says which to switch on now and which to leave until there's a team.

"Enterprise grade" here means: a stranger (or an AI agent) can understand
the code, change it safely, ship it repeatably, and find out quickly when
something breaks. It doesn't mean "as many tools as possible".

## Scorecard

Legend: ✅ in the plan · 🆕 added on this page · ⏳ planned for later.

### Architecture

| Practice | What it means | BLAG | Status |
|---|---|---|---|
| Layered / clean architecture | Business rules don't depend on UI, database or framework | `packages/game-engine` is pure; services use handler → use case → domain → data layers ([backend blueprint](backend-blueprint.md)) | ✅ |
| Bounded contexts (domain services) | Each part of the business owns its data and language | Seven services in the [service map](services.md) | ✅ |
| Architecture decision records | Every big decision written down with options and reasons | `kb/07-architecture/adr/` | ✅ |
| C4 diagrams | Architecture drawn at four levels: context, containers, components, code [S-73] | Context and containers in the [architecture overview](README.md); components in the [backend blueprint](backend-blueprint.md) | ✅ |
| Contract-first APIs | Request, response and event shapes defined once and shared | `packages/contracts` | ✅ |
| Config separate from code | Anything that changes between deploys lives in the environment, not in code [S-74] | Env vars per environment; secrets in Supabase and EAS stores | ✅ |

### Code quality

| Practice | BLAG | Status |
|---|---|---|
| Strict TypeScript everywhere | `tsconfig.base.json` with `strict: true` | ✅ |
| Lint and format | Shared ESLint and Prettier in `packages/config` | ✅ |
| Enforced import boundaries | Lint rule in CI (ADR-009) | ✅ |
| Conventional Commits | Commit messages like `feat(game): add early reveal`, which tools turn into changelogs and version numbers [S-75] | 🆕 `commitlint` in CI |
| Semantic versioning and changelog | App version and `CHANGELOG.md` generated from commits | 🆕 Changesets or release-please |
| Code owners and pull-request template | Who reviews what; a checklist on every PR (red lines, tests, KB updated) | 🆕 `.github/CODEOWNERS`, `.github/pull_request_template.md` |
| Automated dependency updates | Weekly update PRs, grouped | 🆕 Renovate or Dependabot |

### Testing

| Practice | BLAG | Status |
|---|---|---|
| Test pyramid | Many unit tests (game engine), fewer integration (functions, access rules), few end-to-end (Maestro) | ✅ [quality](../11-quality/README.md) |
| Coverage gate on core rules | 95%+ line coverage on `game-engine`; no gate elsewhere at first | 🆕 |
| Access-rule tests | Every row of the who-can-read table is a test | ✅ |
| Contract tests | Schemas in `packages/contracts` validated on both sides | 🆕 |

### Security

| Practice | BLAG | Status |
|---|---|---|
| Threat model | [Threat model](../10-privacy-security/threat-model.md) | ✅ |
| Mobile security checklist | OWASP MASVS self-assessment before beta | ✅ |
| Secret scanning | GitHub secret scanning + push protection | 🆕 |
| Static analysis | CodeQL on TypeScript | 🆕 |
| Least privilege | Service-role key only inside functions; row-level security for every client read | ✅ |
| Security policy | `SECURITY.md` with how to report a problem | 🆕 |

### Operations

| Practice | BLAG | Status |
|---|---|---|
| Separate environments | local, preview, production | ✅ |
| CI/CD | Checks on every PR; deploy functions and migrations from `main` | ✅ (workflow drafted in `scripts/ci/`) |
| Service-level objectives | e.g. reveals visible within 2 minutes of reveal time ([backend blueprint](backend-blueprint.md#service-level-objectives)) | 🆕 |
| Observability | Structured logs with request and event ids; key metrics; alerts | 🆕 [backend blueprint](backend-blueprint.md#observability) |
| Runbooks | Step-by-step fixes for known failures | 🆕 [backend blueprint](backend-blueprint.md#runbooks) |
| Backups and restore drill | Supabase backups; one restore rehearsal before beta | ⏳ |
| Feature flags | Turn features on per circle or per release | 🆕 `src/config/flags.ts`, values from the server |

### Data, accessibility and docs

| Practice | BLAG | Status |
|---|---|---|
| Versioned migrations | `supabase/migrations/`, never edited after merge | ✅ |
| Data ownership and retention | [Service map](services.md), [data inventory](../10-privacy-security/data-inventory.md) | ✅ |
| Accessibility standard | WCAG 2.2 AA | ✅ |
| Internationalisation-ready | Strings in catalogues from day one | ✅ |
| Living documentation | This KB, generated indexes, `AGENTS.md` | ✅ |

## Files added to the repository plan

```text
.github/
├── workflows/
│   ├── ci.yml                   # lint, types, boundaries, unit + access-rule tests, kb check
│   ├── e2e.yml                  # Maestro flows on preview builds (nightly)
│   ├── deploy-backend.yml       # migrations + Edge Functions on merge to main
│   ├── codeql.yml               # static security analysis
│   └── kb.yml                   # knowledge-base site (currently scripts/ci/kb-workflow.yml)
├── CODEOWNERS
├── pull_request_template.md
├── ISSUE_TEMPLATE/              # bug, feature, research question
└── renovate.json (or dependabot.yml)
.changeset/                      # release notes and versions (if Changesets is chosen)
commitlint.config.js
SECURITY.md
```

These are reflected in the [repository structure](repository-structure.md).

## Right-sizing for one person

| Switch on at the start | Leave until there's a team or users |
|---|---|
| Strict types, lint, import boundaries | Coverage gates outside the game engine |
| Game-engine and access-rule tests | Nightly end-to-end runs |
| Conventional Commits | CODEOWNERS (you own everything for now) |
| Secret scanning, CodeQL | Remote build cache |
| Environments and secrets handling | Formal on-call and incident process |
| ADRs and the KB | Separate database schemas per service |

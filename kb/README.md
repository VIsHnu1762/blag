# BLAG knowledge base

This is the single place where everything about BLAG is researched, decided
and logged **before** development starts. If it isn't written here, it hasn't
been decided.

## Sections

| # | Section | Answers the question | Status |
|---|---|---|---|
| 1 | [idea/](idea/README.md) | What is BLAG, why should it exist, and what have others learned? | Drafted |
| 2 | [users/](users/README.md) | Who exactly is it for, and who is it not for? | Seeded |
| 3 | [features/](features/README.md) | What does it do, and in what order do we build it? | Seeded |
| 4 | [brand/](brand/README.md) | How does it look, sound and feel? | Seeded |
| 5 | [design/](design/README.md) | What are the screens, flows and emotional moments? | Seeded |
| 6 | [architecture/](architecture/README.md) | How do the parts fit together and stay fair and private? | Seeded |
| 7 | [tech-stack/](tech-stack/README.md) | Which tools do we use, and why? | Seeded |
| 8 | [mobile-dependencies/](mobile-dependencies/README.md) | What do iOS and Android actually allow? | Seeded, first research done |

Work through them roughly in this order. Each one depends on the one before:
the idea decides the users, the users decide the features, and so on.

## Conventions

Every claim in this knowledge base carries one of these labels when it matters:

| Label | Meaning |
|---|---|
| **Fact** | Verified against a source listed in that section's research log |
| **Estimate** | Comes from a third-party estimate (app analytics firms, press). Treat numbers as rough |
| **Assumption** | Something we believe but haven't tested. Must appear in the assumptions list |
| **Decision** | Agreed by the team and recorded in the decision log |
| **Proposal** | Suggested, not yet agreed |

Other rules:

- **Cite sources.** Every section has a research log with links and the date we checked them.
- **Date everything.** Platform rules and app numbers change. Write the date beside anything that can go stale.
- **Paraphrase, don't paste.** Summarise sources in our own words and link to them.
- **Decisions go in the log.** Use [`idea/10-decision-log.md`](idea/10-decision-log.md) until each section gets its own.
- **Questions go in the open-questions list.** Use [`idea/09-open-questions.md`](idea/09-open-questions.md).

## Readiness gate

Development starts only when:

- [ ] The idea section is reviewed and its open questions are answered or parked
- [ ] The two-week hand-run test has been done (see [`idea/08-risks-and-assumptions.md`](idea/08-risks-and-assumptions.md))
- [ ] Users, features, brand and design are drafted
- [ ] Architecture, tech stack and mobile dependencies are drafted and the iOS data question is settled
- [ ] MVP scope is frozen

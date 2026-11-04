# Contributing to the BLAG knowledge base

Anyone on the team (and any AI agent, see [AGENTS.md](AGENTS.md)) can improve the
KB. The rules are simple so it stays trustworthy.

## The two kinds of files

| Kind | Where | How to edit |
|---|---|---|
| **Pages** (explanations, specs, plans) | `kb/**/*.md` | Edit directly. Keep the frontmatter at the top |
| **Registers** (lists with ids) | `kb/data/*.yaml` | Edit the YAML, then run the build. The tables in `kb/registers/` are generated |

Never edit generated files: `kb/registers/*.md`, `kb/00-start-here/glossary.md`,
`kb/export/*`, `llms.txt`. The build overwrites them.

## Everyday tasks

| I want to… | Do this |
|---|---|
| Add an idea | Add an entry to `kb/data/ideas.yaml` with the next `P-` id |
| Record a decision | Add to `kb/data/decisions.yaml` with the next `D-` id. Use `Proposed` until the team agrees |
| Answer an open question | Add the decision, then set the question's `status: Decided` and `decided_by: D-nn` |
| Cite research | Add to `kb/data/sources.yaml` with URL, quality (A/B/C) and date checked |
| Add a page | Copy [the template](kb/00-start-here/doc-template.md) into the right section |
| Make an architecture decision | Copy an existing ADR in `kb/07-architecture/adr/` and give it the next number |

## Before you push

```bash
pip install pyyaml
python scripts/kb.py build
python scripts/kb.py check    # must say "0 problems"
```

## Writing rules

- Open every page with `> **In short:** …` in one sentence.
- Label claims as **Fact** (cite `S-nn`), **Estimate**, **Assumption**, **Decision** (cite `D-nn`) or **Proposal**.
- Use the [glossary](kb/00-start-here/glossary.md) words.
- Respect the [red lines](kb/01-idea/05-principles-and-red-lines.md).
- Update `last_updated` in the frontmatter.

## Publish the website

The KB can be browsed as a searchable website built with MkDocs Material.

**Preview locally:**

```bash
pip install -r requirements-docs.txt
mkdocs serve        # open http://127.0.0.1:8000
```

**Publish on GitHub Pages (one-time setup, about 2 minutes):**

1. Move the ready-made workflow into place and push it from your own machine:
   ```bash
   mkdir -p .github/workflows
   git mv scripts/ci/kb-workflow.yml .github/workflows/kb.yml
   git commit -m "Add KB check and site workflow" && git push
   ```
2. In the repository go to **Settings → Pages → Build and deployment → Source** and choose **GitHub Actions**.

After that, every push to `main` runs `scripts/kb.py check` and rebuilds the
site at <https://vishnu1762.github.io/blag>.

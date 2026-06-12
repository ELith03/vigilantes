# `/docs` — Template Reference Files

This directory holds **reference templates** that the agent uses to scaffold
new design spec and implementation plan files when the relevant skill fires.

It is not a documentation folder. It is not a planning history. The only
files in this directory are templates that another file is required to copy
from.

## Why a templates-only directory

- The plugin is public. Keeping a slim `/docs` makes the repo's purpose
  immediately legible to anyone browsing on GitHub.
- Templates have one job: define the structure of files the agent will
  write. Keeping them centralized means one place to update structure.
- Anything that is not a template (planning history, contributor guides,
  per-harness install docs, methodology overviews) lives elsewhere — see
  the top-level `README.md` and `METHODOLOGY.md` for the public-facing
  narrative.

## Templates in this directory

| Template | Used by | Output path |
|----------|---------|-------------|
| `vigilantes/specs/_template.md` | `brainstorming` skill (Phase 9: Spec write + self-review) | `docs/vigilantes/specs/YYYY-MM-DD-<topic>-design.md` |
| `vigilantes/plans/_template.md` | `writing-plans` skill (Phase 8: Handoff) | `docs/vigilantes/plans/YYYY-MM-DD-<feature-or-task>.md` |

## ⚠️ Do not delete the template files

The agent's workflow depends on these files existing at these exact paths.
The corresponding skills (`brainstorming`, `writing-plans`) reference these
paths by name. Removing or renaming a template file will break the agent's
ability to scaffold new specs and plans.

If you need to change the structure of generated specs or plans, edit the
template file AND update the corresponding phase in the skill's `SKILL.md`
to match.

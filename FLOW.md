# Vigilantes Flow

The canonical step-by-step flow for the vigilantes methodology. Use this when
you land in a fresh session and need to know "what comes next?" — or invoke
the `vigilantes:start` skill and let it detect where you are.

This map is for the **user-project flow** (the work a developer does on a
project that uses vigilantes). The plugin's own internal skills (e.g.,
`vigilantes:using-vigilantes`, `vigilantes:start`) are not part of this map.

## The 5-step flow

| # | Step | Skill | What you should have at the end |
|---|------|-------|----------------------------------|
| 1 | **Brainstorm** the change | `vigilantes:brainstorming` | An approved design spec at `docs/vigilantes/specs/YYYY-MM-DD-<topic>-design.md` |
| 2 | **Plan** the implementation | `vigilantes:writing-plans` | An approved bite-sized plan at `docs/vigilantes/plans/YYYY-MM-DD-<feature>-plan.md` |
| 3 | **Execute** with TDD | `vigilantes:test-driven-development` + `vigilantes:executing-plans` (or `vigilantes:subagent-driven-development`) | Working code, all tests green, commit history clean |
| 4 | **Review** between tasks | `vigilantes:requesting-code-review` + (when reviewing others) `vigilantes:receiving-code-review` | Each task reviewed against the plan; critical issues fixed before continuing |
| 5 | **Finish** the branch | `vigilantes:finishing-a-development-branch` | A merged PR (or a decision: keep / discard / merge) |

## When to deviate

- **Bug fix on existing code?** Skip Step 1 (no spec needed for a 1-line fix). Go straight to Step 3 with `vigilantes:systematic-debugging` first.
- **Tiny cosmetic change?** Skip Steps 1, 2, 4. Step 3 only, with the TDD skill deciding whether a test is warranted.
- **Large feature with multiple independent subsystems?** Decompose at Step 1 — one spec per subsystem, then plan and execute each independently.
- **Picking up after a break?** Invoke `vigilantes:start` — it detects your state from the working directory and routes you to the right step.

## Related docs

- `README.md` — install + high-level overview.
- `METHODOLOGY.md` — the 10-principle library + skill catalog (the "voice" of the methodology).
- `docs/vigilantes/specs/_template.md` — template for new design specs (used by `vigilantes:brainstorming`).
- `docs/vigilantes/plans/_template.md` — template for new implementation plans (used by `vigilantes:writing-plans`).

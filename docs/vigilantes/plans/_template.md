<!--
⚠️ DO NOT DELETE THIS FILE

This is a reference template used by the `writing-plans` skill to scaffold
new implementation plan files. When `writing-plans` reaches Phase 8
(Handoff), the agent copies this file to a new plan path
(typically `docs/vigilantes/plans/YYYY-MM-DD-<feature-or-task>.md`) and
fills in the sections.

The template is the contract. Do not change the section headings; the
implementer (and reviewers) rely on them. If you need to change the
structure of generated plans, edit this template AND update the
corresponding phase in `skills/writing-plans/SKILL.md` to match.

Risk-class-driven structure: the body sections below cover a medium-risk
plan. For low-risk plans, the Risk register / Rollback plan / Step
ordering rationale sections are omitted. For high-risk plans, all three
are filled in.
-->

# Plan: <Task>

**Risk class:** Low | Medium | High
**Date:** YYYY-MM-DD
**Author:** <agent or user>
**Design:** <link to spec or "in this conversation">

## Principles in play

Cite 2-4 of the 10 principles (full definitions are inlined in
`skills/writing-plans/SKILL.md`). For each, name the one-sentence
application to this specific plan.

- **<Principle name>** — <how it shapes this plan>
- **<Principle name>** — <how it shapes this plan>

## Task

<one-paragraph restatement of the design's intent, in the implementer's voice>

## Files to create / modify

- `<path>` — <what changes and why>
- `<path>` — <what changes and why>

## Step-by-step

### Step 1: <action>

**File:** `<path>`
**Code:**
```ts
// complete code
```
**Verification:** <one sentence: what to run, what to see>
**Rollback:** <one sentence: how to revert; omit if fully reversible>
**Test pairing:** <cite the TDD test step that precedes this; omit if not a behavior change>

### Step 2: <action>

**File:** `<path>`
**Code:**
```ts
// complete code
```
**Verification:** <one sentence>
**Rollback:** <one sentence; omit if reversible>

## Verification

- All tests pass: `<test command>`
- New behavior works end-to-end: `<manual or automated check>`
- No existing tests regress: `<coverage command>` shows no drop

## Done when

- All Step-* verification lines run green.
- Coverage is at or above the pre-change level.
- The user has signed off on the plan's execution.

<!--
The three sections below are required for high-risk plans; optional for
medium-risk plans when no steps in the plan are flagged as risky. For
low-risk plans, omit them entirely.
-->

## Risk register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| <risk> | Low/Medium/High | Low/Medium/High | <how we mitigate> |

## Rollback plan

- **Step N (<name>):** <one-line rollback; verified in staging>
- **Step N+M (<name>):** <one-line rollback>

## Step ordering rationale

Steps are ordered by reversibility. The first half of the plan is fully
reversible via `git revert`. The second half introduces non-reversible
changes; each carries a rollback line. The implementer may pause after
the reversible portion and ship it, then continue with the non-reversible
portion in a follow-up release.

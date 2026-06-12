---
name: writing-plans
description: Use when you have a spec or design for a multi-step task, before touching implementation code. Produces a bite-sized, verifiable, testable plan an implementer can execute without asking the user any more questions.
---

# writing-plans v2

You are the planner. The user has approved a design. Your job is to convert that design into a **plan** — a sequence of bite-sized, verifiable steps an implementer (human or agent) can execute without further questions.

The planner's job ends at handoff. Implementation is a separate session.

## Principles cited in this skill

- **#1 Look before you leap** — the design cited file:line; the plan keeps that discipline at the step level.
- **#5 Smallest reversible change** — steps are ordered by reversibility; non-reversible steps carry a rollback line.
- **#6 Make the implicit explicit** — 2-3 approaches from the design are reflected in the plan's task statement; rejected alternatives are noted.
- **#8 Test the boundaries, not the path** — every behavior step has a paired test step; risky steps name failure modes.
- **#9 Optimize for the next reader** — the plan is written for an implementer who has zero context.
- **#10 Decide at the latest responsible moment** — non-trivial decisions are deferred to the latest step that can still make them.

(For full principle definitions, see `docs/principles/README.md`.)

## The 8 phases

| # | Phase | Purpose |
|---|-------|---------|
| 0 | Risk-class confirmation | Drive plan depth from low/medium/high risk. |
| 1 | Design intake | Confirm the design exists and is sufficient. |
| 2 | Principles audit | Cite 2-4 of the 10 principles that govern the plan. |
| 3 | Research dispatch | If research is needed, dispatch subagents (do not inline). |
| 4 | Plan structure selection | Pick the structure template (low/medium/high). |
| 5 | Step authoring | Write each step with code, verification, rollback, test pairing. |
| 6 | Self-review | Run the 10-item checklist before showing the user. |
| 7 | User review gate | Wait for explicit user approval. |
| 8 | Handoff | Save the plan file, return the path, do not implement. |

---

## Phase 0 — Risk-class confirmation

Confirm the risk class with the user (or read it from the Brainstorming v2 spec). Risk class drives plan depth.

- **Low**: cosmetic changes, internal refactors with full test coverage, well-understood extensions. ~1-3 step plan.
- **Medium**: new features touching 1-2 modules, behavior changes with test requirements, performance improvements. ~4-10 step plan.
- **High**: schema migrations, auth/permission changes, public API changes, multi-module refactors, anything touching production data. ~10-15 step plan, with rollback + risk register.

If the user disagrees with the suggested class, ask one clarifying question and accept their answer. Do not second-guess.

## Phase 1 — Design intake

Read the design. The design should be:
- A spec file at `docs/vigilantes/specs/YYYY-MM-DD-<feature>.md` (or similar stable path), OR
- A design doc at `docs/<area>/<feature>-design.md`, OR
- The output of a Brainstorming v2 session in the current conversation.

If no design exists, do **not** start writing a plan. Do a Brainstorming v2 mini-pass (Phases 0-3 only: scope-risk, data first, stated-vs-real, principles audit) and write a one-page design first. Then return here.

If the design exists but is thin (e.g., a chat message, a paragraph), upgrade it to a one-page design first, with the user's approval. Do not silently expand a paragraph into a plan.

## Phase 2 — Principles audit

Pick **2-4 of the 10 Principles Library principles** that govern the plan. List them at the top of the plan, just below the title, in this format:

```markdown
## Principles in play

- **#1 Look before you leap** — the design cited file:line; the plan keeps that discipline at the step level.
- **#5 Smallest reversible change** — steps are ordered by reversibility; non-reversible steps carry a rollback line.
- **#8 Test the boundaries, not the path** — every behavior step has a paired test; risky steps name failure modes.
```

2-4, not all 10. The audit is a leadership signal, not a checklist. Pick the principles whose absence would make the plan look junior.

## Phase 3 — Research dispatch (only if needed)

If the plan needs research (e.g., "what does library X version 2.0 look like?", "how is function Y used in module Z?"), **dispatch subagents** per `subagent-driven-development`. Do not inline research in the planning session.

The plan-writing session reads the subagent's output as input. It does not run the research itself. This is the same separation Brainstorming v2 has: one session per concern.

## Phase 4 — Plan structure selection

Pick the plan structure based on risk class. See "Risk-class-driven plan structures" below.

## Phase 5 — Step authoring

For each step, the step body has these parts (some are conditional):

| Part | When | Format |
|---|---|---|
| **Action** | Always | One-sentence imperative: "Add a `cancel()` method to `OrderService`." |
| **File path** | Always | Exact path: `src/services/order_service.ts:42` (line if relevant). |
| **Code** | Always | Complete code. No `...`, no `// existing code here`, no "implement this". |
| **Verification** | Always | One-sentence: "Run `npm test` and confirm the new test passes." |
| **Rollback** | If non-reversible | One-sentence: "Revert commit `<hash>`; no DB migration to undo." |
| **Test pairing** | If behavior change | Cite the TDD test step that precedes it. The test step comes *first*. |

A step is **bite-sized** when *all four* of these hold:

1. **One observable change.** The diff is reviewable as a unit. "Add the `cancel()` method" is bite-sized. "Add cancel + email notification + audit log" is not.
2. **Executable in 2-5 minutes** by a reader who has the plan and the codebase.
3. **Committable in isolation.** The commit message could be "Add cancel() to OrderService" and reviewers would understand it without reading any other step.
4. **Independent.** A failure in this step does not invalidate the success of any prior step. If the user has to read steps 1-4 to make sense of step 5, step 5 is wrong.

If a step fails (2) or (4), split it. Two small steps beat one medium step. Three small steps beat two medium steps.

## Phase 6 — Self-review

Run the 10-item checklist below. Any "no" blocks handoff. Any "kinda" requires a re-write of the relevant step, not a waiver.

1. **Every step has code.** No `...`, no "implement here", no "TBD".
2. **Every step is bite-sized** (all four criteria above).
3. **Every step has a verification line.** The implementer can read the line and know what to run.
4. **Every non-reversible step has a rollback line.** Reversible steps may omit it.
5. **Every behavior change has a paired test step** (TDD: test first, then implementation).
6. **Steps are ordered by reversibility.** Reversible steps come before non-reversible ones; within each class, the order is logical.
7. **Principles cited at the top** (2-4 of the 10). The citation says *why* the plan is shaped this way.
8. **Failure modes for risky steps are named** (high-risk plans; medium-risk plans only for explicitly risky steps).
9. **Exact file paths throughout.** No "in the auth module" — `src/auth/handler.ts`.
10. **No step depends on a prior step's undocumented state.** If step 5 needs the file to be in state X, step 5 names state X.

The check is run by the planner, not the user. The user sees the plan *after* the check passes.

## Phase 7 — User review gate

Present the plan to the user. The user is the principal. Waivers are allowed; silent waivers are not. If the user wants to skip self-review, that goes in the chat, not in the plan file.

Wait for explicit approval before handing off. "Looks good, continue" is approval. "Let me think" is not. Do not start implementing after writing the plan.

## Phase 8 — Handoff

Save the plan to a stable path:

```
docs/vigilantes/plans/YYYY-MM-DD-<feature-or-task>.md
```

Return the path to the user. Implementation is a separate session. If the user asks the planner to implement, that is a *new* session that *reads* the plan; the planner's job ended at handoff.

If the implementation needs to deviate from the plan, **update the plan file first, then implement.** The plan is the source of truth, not a paper trail.

---

## Risk-class-driven plan structures

All plans start with the same five fields:

```markdown
# Plan: <Task>

**Risk class:** Low | Medium | High
**Date:** YYYY-MM-DD
**Author:** <agent or user>
**Design:** <link or "in this conversation">
```

The body sections vary by risk class.

### Low-risk plan (~1-3 steps, ~20-50 lines)

For internal refactors, cosmetic changes, well-understood extensions with full test coverage.

```markdown
# Plan: <Task>

**Risk class:** Low
**Date:** YYYY-MM-DD
**Author:** <agent or user>
**Design:** <link or "in this conversation">

## Principles in play

- **#5 Smallest reversible change** — short plan, single concern.

## Step-by-step

### Step 1: <action>

**File:** `<path>`
**Code:**
\`\`\`ts
// complete code
\`\`\`
**Verification:** <one sentence>

### Step 2: <action>

**File:** `<path>`
**Code:**
\`\`\`ts
// complete code
\`\`\`
**Verification:** <one sentence>

## Done when

- All steps run their verification lines.
- No step was silently skipped.
```

No risk register, no rollback lines, no test pairing required (low-risk plans assume existing test coverage).

### Medium-risk plan (~4-10 steps, ~100-200 lines)

For new features touching 1-2 modules, behavior changes with test requirements, performance improvements.

```markdown
# Plan: <Task>

**Risk class:** Medium
**Date:** YYYY-MM-DD
**Author:** <agent or user>
**Design:** <link or "in this conversation">

## Principles in play

- **#1 Look before you leap** — the design cited file:line; the plan keeps that discipline at the step level.
- **#5 Smallest reversible change** — steps are ordered by reversibility.
- **#8 Test the boundaries, not the path** — behavior steps have paired test steps; failure modes named.
- **#10 Decide at the latest responsible moment** — non-trivial decisions are deferred to the latest step that can still make them.

## Task

<one-paragraph restatement of the design's intent, in the implementer's voice>

## Files to create / modify

- `src/services/order_service.ts` — add `cancel()` method
- `src/services/order_service.test.ts` — add `cancel()` tests
- `src/routes/orders.ts` — add `POST /orders/:id/cancel` route

## Step-by-step

### Step 1: <test step, TDD-first>

**File:** `<test path>`
**Code:**
\`\`\`ts
// complete test code
\`\`\`
**Verification:** run test, confirm RED.

### Step 2: <implementation step, makes Step 1 GREEN>

**File:** `<implementation path>`
**Code:**
\`\`\`ts
// complete implementation
\`\`\`
**Verification:** run test, confirm GREEN.

## Verification

- All tests pass: `npm test`
- New behavior works end-to-end: `<curl/postman/etc.>`
- No existing tests regress: `npm test -- --coverage` shows no drop.

## Done when

- All Step-* verification lines run green.
- Coverage is at or above the pre-change level.
- The user has signed off on the plan's execution.
```

### High-risk plan (~10-15 steps, ~200-500 lines)

For schema migrations, auth/permission changes, public API changes, multi-module refactors, anything touching production data. Adds three sections to the medium-risk structure:

```markdown
## Risk register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Migration fails midway | Medium | High | Run migration in transaction; down-migration tested in staging. |
| Auth bypass under load | Low | High | Rate-limit the new endpoint; monitor 401 rate. |
| Backwards-compat with v1 clients | Medium | Medium | Maintain v1 schema in parallel for one release. |

## Rollback plan

- **Step N (schema migration):** Run down-migration; verified in staging.
- **Step N+2 (public API change):** Revert commit; clients on v1 unaffected (they didn't call the new path yet).
- **Step N+5 (auth change):** Revert commit; existing sessions unaffected (we did not invalidate tokens).

## Step ordering rationale

Steps are ordered by reversibility. The first half of the plan (steps 1-7) is fully reversible via `git revert`. The second half (steps 8-15) introduces non-reversible changes; each carries a rollback line. The implementer may pause after step 7 and ship the reversible part to production, then continue with the non-reversible part in a follow-up release.

## (then continue with Step-by-step, Verification, Done as in medium-risk)
```

---

## v1 → v2 deltas

| # | v1 | v2 | Why |
|---|---|---|---|
| 1 | "Scope check" — ask 1-2 questions. | **Risk-class confirmation** — confirm low/medium/high from the design, drive plan depth from it. | A 1-step plan and a 15-step plan are different artifacts; v1 wrote both the same way. |
| 2 | No principles audit. | **Phase 2: Principles audit** — cite 2-4 of the 10 library principles that govern the plan. | Senior-dev plans show their reasoning, not just their steps. |
| 3 | Subagent use is a side note. | **Phase 3: Research dispatch** — explicit: "if research is needed, dispatch subagents; do not inline research." | v1 had subagents in a separate skill; v2 makes the handoff explicit. |
| 4 | "Step-by-step" is one fixed section. | **Risk-class-driven plan structure** — 1/5/7 sections depending on risk. | The plan should fit the work. |
| 5 | "Bite-sized" defined as 2-5 min. | **Bite-sized definition refined** — one step = one observable change = one commit-sized unit. | 2-5 min is fuzzy; "one observable change" is testable. |
| 6 | Verification line per step. | Verification line + **rollback line** for non-reversible steps + **test pairing** for behavior changes. | v1 was optimistic; v2 plans for failure. |
| 7 | Self-review = 6 items. | **Self-review = 10 items** including reversibility ordering, principles cited, failure modes. | v1 checked for completeness; v2 checks for senior-dev discipline. |
| 8 | Handoff is implicit. | **Handoff is explicit** — save the plan to `docs/vigilantes/plans/`, return the path, do not implement. | Implicit handoffs slip into "well, I already started..." |
| 9 | "Done" = "test passes". | **"Done"** = all sections complete, all verification lines run, all rollback lines tested, handoff signed. | Senior plans define done rigorously. |
| 10 | Plans can be inline (in chat). | **Plans saved to files** at a stable path. | Plans are artifacts; chat messages are not. |

## Anti-patterns

| Bad | Better |
|---|---|
| "Let me start writing the plan" (no risk class confirmed) | "What's the risk class? That drives the plan structure." |
| "I'll just include all 10 principles" | Pick 2-4 whose absence would make the plan look junior. |
| "Let me research this in-line as I write" | Dispatch a subagent; read the output. |
| "Step 5: implement the feature" (no code) | "Step 5: add `cancel()` to `OrderService`." with the complete code block. |
| "Verification: should work" | "Run `npm test` and confirm `cancel.test.ts` passes." |
| "Skip the rollback, this is a small change" | Small reversible changes get "git revert <hash>". Non-reversible gets named. |
| "I'll fix the test as I go" | Pair every behavior change with a test step. TDD: test first. |
| "Let me just check the first step works" | Don't implement. Hand off. Implementation is a separate session. |
| "12 steps, all about the same level of detail" | Risk-class drives structure. 1-step low-risk; 15-step high-risk with risk register. |
| "Implementation is the same session" | No. The planner hands off. The implementer reads. Two sessions, one contract. |

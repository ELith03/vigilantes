# writing-plans v2

**Status:** Draft v1
**Date:** 2026-06-12
**Author:** Vigilantes planning
**Relates to:** `2026-06-12-vigilantes-methodology-roadmap.md`, `2026-06-12-principles-library.md`, `2026-06-12-brainstorming-v2.md`
**Replaces:** `skills/writing-plans/SKILL.md` (v1, 152 lines)
**Depends on:** Rebrand spec (uses `vigilantes` naming)

---

## 1. Overview

writing-plans v2 is the **handoff discipline** of the Vigilantes methodology. Where Brainstorming v2 produces a *design* (a spec the user approves), writing-plans v2 produces a *plan* (a sequence of bite-sized, verifiable, testable steps an implementer can execute without asking the user any more questions).

The two skills are **separated by design**: a single agent doing both designing and planning loses the user's review checkpoint in the middle. v1 got this separation right; v2 sharpens it and brings the rest of the methodology to bear on the plan itself.

writing-plans v2 differs from Brainstorming v2 in three ways:

1. **It consumes a design.** It does not re-derive one. If the design is missing or thin, writing-plans v2 triggers a Brainstorming v2 mini-pass, but that's an exception, not the norm.
2. **It produces code-shaped steps, not decisions.** A plan step is an observable change with a file path, complete code, a verification line, and (for behavior changes) a paired test. Decisions live in the design; execution lives in the plan.
3. **It hands off.** The plan's existence is its completion. Implementation is a separate session, with the implementer (human or agent) reading the plan as a contract.

v2 inherits v1's strengths (bite-sized steps, no placeholders, exact paths, complete code, self-review) and adds four things v1 lacked: a **risk-class-driven plan structure**, an explicit **principles audit at the top**, a **rollback line** for non-reversible steps, and a **test pairing** rule for behavior changes.

## 2. Goals

- **The implementer never has to ask the user a question.** The plan is complete or it isn't shipped.
- **The user reviews the design (in Brainstorming v2) and reviews the plan (here) at two separate checkpoints.** No skipping.
- **The plan is at the right altitude.** Low-risk work gets a short plan; high-risk work gets rigor. One-size-fits-all plans either under-prepare high-risk work or over-prepare low-risk work.
- **The plan is reversible by construction.** Steps are ordered by reversibility, and every non-reversible step has a rollback line.
- **Behavior changes ship with tests, in test-first order.** TDD is operationalized inside the plan, not deferred to the implementer's discipline.
- **The plan cites the principles it embodies.** The user can read a plan and see *why* the steps are ordered this way, not just *that* they are.

## 3. Non-Goals

- writing-plans v2 does **not** do design work. That's Brainstorming v2. If the design is missing, it routes back, it doesn't fill the gap silently.
- writing-plans v2 does **not** do research inline. Research is dispatched to subagents per `subagent-driven-development`. The plan-writing session reads the research output, it doesn't produce it.
- writing-plans v2 does **not** implement. It produces a plan. Implementation is a separate session.
- writing-plans v2 does **not** write test content. It says *which* test step pairs with *which* behavior step; the test code lives in the step body.
- writing-plans v2 does **not** replace the TDD skill. TDD's "iron law" is operationalized *inside* the plan, but the plan author is expected to have read TDD.

## 4. v1 → v2 deltas (concrete)

| # | v1 | v2 | Why |
|---|---|---|---|
| 1 | "Scope check" — ask 1-2 questions. | **Risk-class confirmation** — confirm low/medium/high from the design, drive plan depth from it. | A 1-step plan and a 15-step plan are different artifacts; v1 wrote both the same way. |
| 2 | No principles audit. | **Phase 2: Principles audit** — cite 2-4 of the 10 library principles that govern the plan. | Senior-dev plans show their reasoning, not just their steps. |
| 3 | Subagent use is a side note. | **Phase 3: Research dispatch** — explicit: "if research is needed, dispatch subagents; do not inline research." | v1 had subagents in a separate skill; v2 makes the handoff explicit. |
| 4 | "Step-by-step" is one fixed section. | **Risk-class-driven plan structure** — 1/5/7 sections depending on risk. | The plan should fit the work. |
| 5 | "Bite-sized" defined as 2-5 min. | **Bite-sized definition refined** — one step = one observable change = one commit-sized unit. | 2-5 min is fuzzy; "one observable change" is testable. |
| 6 | Verification line per step. | Verification line + **rollback line** for non-reversible steps + **test pairing** for behavior changes. | v1 was optimistic; v2 plans for failure. |
| 7 | Self-review = 6 items. | **Self-review = 10 items** including reversibility ordering, principles cited, failure modes. | v1 checked for completeness; v2 checks for senior-dev discipline. |
| 8 | Handoff is implicit. | **Handoff is explicit** — save the plan to `docs/superpowers/plans/`, return the path, do not implement. | Implicit handoffs slip into "well, I already started..." |
| 9 | "Done" = "test passes". | **"Done"** = all 5 sections complete, all verification lines run, all rollback lines tested, handoff signed. | Senior plans define done rigorously. |
| 10 | Plans can be inline (in chat). | **Plans saved to files** at a stable path. | Plans are artifacts; chat messages are not. |

## 5. v2 phases

### Phase 0 — Risk-class confirmation

Confirm the risk class with the user (or read it from the Brainstorming v2 spec). Risk class drives plan depth.

- **Low**: cosmetic changes, internal refactors with full test coverage, well-understood extensions. ~1-3 step plan.
- **Medium**: new features touching 1-2 modules, behavior changes with test requirements, performance improvements. ~4-10 step plan.
- **High**: schema migrations, auth/permission changes, public API changes, multi-module refactors, anything touching production data. ~10-15 step plan, with rollback + risk register.

If the user disagrees with the suggested class, ask one clarifying question and accept their answer. Do not second-guess.

### Phase 1 — Design intake

Read the design. The design should be:
- A spec file at `docs/superpowers/specs/YYYY-MM-DD-<feature>.md` (or similar stable path), OR
- A design doc at `docs/<area>/<feature>-design.md`, OR
- The output of a Brainstorming v2 session in the current conversation.

If no design exists, do **not** start writing a plan. Do a Brainstorming v2 mini-pass (Phases 0-3 only: scope-risk, data first, stated-vs-real, principles audit) and write a one-page design first. Then return here.

If the design exists but is thin (e.g., a chat message, a paragraph), upgrade it to a one-page design first, with the user's approval. Do not silently expand a paragraph into a plan.

### Phase 2 — Principles audit

Pick **2-4 of the 10 Principles Library principles** that govern the plan. List them at the top of the plan, just below the title, in this format:

```markdown
## Principles in play

- **#1 Look before you leap** — the design cited file:line; the plan keeps that discipline at the step level.
- **#5 Smallest reversible change** — steps are ordered by reversibility; non-reversible steps carry a rollback line.
- **#8 Test the boundaries, not the path** — every behavior step has a paired test; risky steps name failure modes.
```

2-4, not all 10. The audit is a leadership signal, not a checklist. Pick the principles whose absence would make the plan look junior.

### Phase 3 — Research dispatch (only if needed)

If the plan needs research (e.g., "what does library X version 2.0 look like?", "how is function Y used in module Z?"), **dispatch subagents** per `subagent-driven-development`. Do not inline research in the planning session.

The plan-writing session reads the subagent's output as input. It does not run the research itself. This is the same separation Brainstorming v2 has: one session per concern.

### Phase 4 — Plan structure selection

Pick the plan structure based on risk class. See section 6 for the three structures.

### Phase 5 — Step authoring

For each step, the step body has these parts (some are conditional):

| Part | When | Format |
|---|---|---|
| **Action** | Always | One-sentence imperative: "Add a `cancel()` method to `OrderService`." |
| **File path** | Always | Exact path: `src/services/order_service.ts:42` (line if relevant). |
| **Code** | Always | Complete code. No `...`, no `// existing code here`, no "implement this". |
| **Verification** | Always | One-sentence: "Run `npm test` and confirm the new test passes." OR "Send a GET to `/orders/123/cancel` and confirm 200." |
| **Rollback** | If the step is non-reversible | One-sentence: "Revert commit `<hash>`; no DB migration to undo." OR "Cannot rollback: schema change. Mitigation: write the migration's down migration in the same step." |
| **Test pairing** | If the step is a behavior change | Cite the TDD test step that precedes it. The test step comes *first*. |

A step is **bite-sized** when:
1. It is one observable change (one new function, one modified line group, one test).
2. A reader who has never seen the codebase can execute it in 2-5 minutes.
3. It can be committed in isolation (its diff is reviewable on its own).
4. It is independent: a failure in this step does not invalidate any prior step's success.

If a step fails (2) or (4), split it.

### Phase 6 — Self-review

Run the 10-item checklist in section 9. Any "no" blocks handoff. Any "kinda" requires a re-write of the relevant step, not a waiver.

### Phase 7 — User review gate

Present the plan to the user. The user is the principal. Waivers are allowed; silent waivers are not. If the user wants to skip self-review, that goes in the chat, not in the plan file.

Wait for explicit approval before handing off. "Looks good, continue" is approval. "Let me think" is not. Do not start implementing after writing the plan.

### Phase 8 — Handoff

Save the plan to a stable path:

```
docs/superpowers/plans/YYYY-MM-DD-<feature-or-task>.md
```

Return the path to the user. Implementation is a separate session. If the user asks the planner to implement, that is a *new* session that *reads* the plan; the planner's job ended at handoff.

If the implementation needs to deviate from the plan, **update the plan file first, then implement.** The plan is the source of truth, not a paper trail.

## 6. Risk-class-driven plan structure

### 6.1 Low-risk plan (~1-3 steps, ~20-50 lines)

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

### 6.2 Medium-risk plan (~4-10 steps, ~100-200 lines)

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

### Step 3: ...

## Verification

- All tests pass: `npm test`
- New behavior works end-to-end: `<curl/postman/etc.>`
- No existing tests regress: `npm test -- --coverage` shows no drop.

## Done when

- All Step-* verification lines run green.
- Coverage is at or above the pre-change level.
- The user has signed off on the plan's execution.
```

### 6.3 High-risk plan (~10-15 steps, ~200-500 lines)

For schema migrations, auth/permission changes, public API changes, multi-module refactors, anything touching production data.

Adds three sections to the medium-risk structure:

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

## 7. Plan template reference

All plans start with the same five fields:

```markdown
# Plan: <Task>

**Risk class:** Low | Medium | High
**Date:** YYYY-MM-DD
**Author:** <agent or user>
**Design:** <link or "in this conversation">
```

The body sections vary by risk class (section 6).

## 8. Bite-sized step — refined definition

A step is bite-sized when **all four** of these hold:

1. **One observable change.** The diff is reviewable as a unit. "Add the `cancel()` method" is bite-sized. "Add cancel + email notification + audit log" is not.
2. **Executable in 2-5 minutes** by a reader who has the plan and the codebase. If a step takes longer than 5 min, it bundles too much.
3. **Committable in isolation.** The commit message could be "Add cancel() to OrderService" and reviewers would understand it without reading any other step.
4. **Independent.** A failure in this step does not invalidate the success of any prior step. If the user has to read steps 1-4 to make sense of step 5, step 5 is wrong.

When in doubt, **split**. Two small steps are better than one medium step. Three small steps are better than two medium steps.

## 9. Self-review checklist (10 items)

Before showing the plan to the user, run this checklist. Any "no" blocks handoff. Any "kinda" requires a step re-write, not a waiver.

1. **Every step has code.** No `...`, no "implement here", no "TBD".
2. **Every step is bite-sized** (section 8: all four criteria).
3. **Every step has a verification line.** The implementer can read the line and know what to run.
4. **Every non-reversible step has a rollback line.** Reversible steps may omit it.
5. **Every behavior change has a paired test step** (TDD: test first, then implementation).
6. **Steps are ordered by reversibility.** Reversible steps come before non-reversible ones; within each class, the order is logical.
7. **Principles cited at the top** (2-4 of the 10). The citation says *why* the plan is shaped this way.
8. **Failure modes for risky steps are named** (high-risk plans; medium-risk plans only for explicitly risky steps).
9. **Exact file paths throughout.** No "in the auth module" — `src/auth/handler.ts`.
10. **No step depends on a prior step's undocumented state.** If step 5 needs the file to be in state X, step 5 names state X.

The check is run by the planner, not the user. The user sees the plan *after* the check passes.

## 10. Handoff discipline

The plan is **complete** when:

- The plan file is saved at `docs/superpowers/plans/YYYY-MM-DD-<task>.md`.
- Self-review has passed (section 9, all 10 items).
- The user has explicitly approved the plan in chat.
- The path has been returned to the user.

The planner's job ends at handoff. The planner **does not**:

- Start implementing the plan in the same session.
- "Just check that the first step works" before handing off.
- Edit the plan file after the user has approved it, except to reflect implementation deviations (and only after the deviation is decided).

If the user asks the planner to implement, the planner says: "This plan is complete and saved at `<path>`. To implement, start a new session and ask the implementer to read the plan first." Implementation in a new session is the *correct* path; the user benefits from the same separation Brainstorming v2 enforces.

## 11. Worked example: planning a "reset password" feature

User prompt: "Add a 'reset password' button to the login page."

This is **medium-risk** (new feature touching 1-2 modules, behavior change, public-facing).

**Brainstorming v2 output (already done in this session):**
- Spec file: `docs/superpowers/specs/2026-06-12-reset-password.md`
- Approach: extend existing `requestPasswordReset` API; add a button to the login page; reuse the email-sending infrastructure.
- Failure modes named: empty input, email enumeration, rate limiting, expired tokens, sensitive data in logs.

**writing-plans v2 plan:**

```markdown
# Plan: Add password-reset button to login page

**Risk class:** Medium
**Date:** 2026-06-12
**Author:** writing-plans v2
**Design:** docs/superpowers/specs/2026-06-12-reset-password.md

## Principles in play

- **#1 Look before you leap** — the design cited `src/auth/handler.ts:142` (the existing `requestPasswordReset` handler); the plan keeps the steps inside the same module.
- **#5 Smallest reversible change** — steps are reversible via `git revert` until step 7; the email-sending change is non-reversible once sent, but the code change is reversible.
- **#8 Test the boundaries, not the path** — behavior steps have paired test steps; failure modes from the design are tested.
- **#6 Make the implicit explicit** — the design presented 2 approaches; the plan implements the recommended one and notes why the rejected one is documented in the spec.

## Task

Implement the password-reset button on the login page, reusing the existing `requestPasswordReset` API and email-sending infrastructure. Per the design's approach 1.

## Files to create / modify

- `src/components/LoginForm.tsx` — add "Forgot password?" link
- `src/components/ResetPasswordForm.tsx` — new file, the form for entering the email
- `src/routes/auth.ts` — add `GET /reset-password` route
- `src/auth/handler.ts` — extend `requestPasswordReset` to accept the new flow
- `src/auth/handler.test.ts` — add tests
- `src/components/ResetPasswordForm.test.tsx` — new test file
- `src/services/email_service.ts` — extend template list

## Step-by-step

### Step 1: Test the new `requestPasswordReset` failure modes (RED)

**File:** `src/auth/handler.test.ts`
**Code:**
\`\`\`ts
test('rejects empty email', async () => {
  await expect(handler.requestPasswordReset('')).rejects.toThrow('email required');
});
test('rejects malformed email', async () => {
  await expect(handler.requestPasswordReset('not-an-email')).rejects.toThrow('invalid email');
});
test('rate-limits after 5 requests in 1 minute', async () => {
  // run 5 requests, 6th should be rate-limited
});
\`\`\`
**Verification:** `npm test -- handler.test.ts`, confirm all RED.

### Step 2: Extend `requestPasswordReset` to make Step 1 GREEN

**File:** `src/auth/handler.ts:142`
**Code:** [complete implementation, with empty-email guard, regex validation, rate-limit middleware call]
**Verification:** `npm test -- handler.test.ts`, confirm all GREEN.

(... continue with steps 3-8: component, route, email template, integration test, manual smoke test, documentation update ...)

## Verification

- All unit tests pass: `npm test`
- Integration test for end-to-end reset flow passes
- Manual smoke test: click "Forgot password?" → enter email → receive email
- No regression in existing login flow: `npm test -- LoginForm`

## Done when

- All Step-* verification lines run green
- Coverage on `src/auth/handler.ts` is at or above 90%
- The user has signed off
```

This is 8 steps, ~150 lines. The plan is complete; the implementer needs no further questions.

## 12. Acceptance test

writing-plans v2 is ready when:

- [ ] The SKILL.md is 280-350 lines (cap maintained).
- [ ] All 10 v1 → v2 deltas in section 4 are present in the SKILL.md.
- [ ] The 8 phases in section 5 are present in the SKILL.md.
- [ ] The risk-class-driven plan structures in section 6 are present as templates.
- [ ] The 10-item self-review checklist in section 9 is verbatim in the SKILL.md.
- [ ] The bite-sized step definition in section 8 is verbatim in the SKILL.md.
- [ ] The handoff discipline in section 10 is verbatim in the SKILL.md.
- [ ] The worked example (section 11) is included in the visual-companion (or a similar companion doc) — the SKILL.md stays under the 350-line cap.
- [ ] The "Principles cited in this skill" summary at the top of the SKILL.md lists the principles from section 2 of the Principles Library spec (those that apply to plan-writing).
- [ ] A side-by-side comparison test: take a real medium-risk task the user has done before (in v1 mode), plan it with v2, and confirm: (a) plan is more rigorous (rollback lines, test pairings, principles cited), (b) implementer can execute without asking the user, (c) plan is reviewable in 5 minutes.

## 13. Risks + mitigations

| Risk | Mitigation |
|---|---|
| v2 is heavier than v1; users may resist the rigor. | Risk-class-driven structure: low-risk plans are short. The 200-line medium-risk plan is opt-in by risk class, not mandatory. |
| Risk-class labeling is itself a decision the user must approve. | Phase 0: confirm risk class with the user. If disagreement, accept the user's class. Do not over-engineer. |
| "Principles cited" becomes performative. | 2-4 principles, not all 10. Section 5 + the worked example show selective citation. The audit is a leadership signal, not a checklist. |
| Test pairing for every behavior change makes plans longer. | Yes, by design. A plan without test pairing is a plan that ships bugs. The TDD skill already requires this; v2 makes the requirement visible in the plan. |
| Step-ordering-by-reversibility conflicts with logical ordering. | In practice they coincide: logical order *is* reversibility-ordered (write code before data, run tests before deploy, deploy reversible steps before non-reversible). When they conflict, reversibility wins. |
| "Implementation in a new session" is friction. | True. The friction is the point: implementation should be a deliberate, reviewable act, not a continuation of the planning chat. |
| Plans stored as files drift from implementation. | The handoff discipline (section 10) says: "Update the plan file first, then implement." The plan is the source of truth. |
| Subagent research is overkill for small plans. | Phase 3 is conditional: "if research is needed". Low-risk plans often skip it. |

## 14. Open questions

1. **Should the SKILL.md include all three risk-class templates inline, or only one + pointers to the others?**
   *Proposed:* Include all three inline. The user reads one plan at a time; the relevant template is the one matching the risk class, and inlining keeps the SKILL.md self-contained.

2. **Where should the visual companion / worked example live?**
   *Proposed:* `skills/writing-plans/visual-companion.md` (mirroring brainstorming's pattern). The worked example is long; putting it in the SKILL.md breaks the 350-line cap.

3. **What if a plan has zero behavior changes** (pure refactor, no test changes needed)?
   *Proposed:* Test pairing is conditional on behavior change. A pure refactor plan has no test steps. Self-review item 5 is "every behavior change" — if there are no behavior changes, the item is N/A.

4. **What if the user asks for a plan before the design exists?**
   *Proposed:* writing-plans v2 routes back to Brainstorming v2 (Phase 1 mini-pass). It does not write a plan on a paragraph of design — that produces plans that need to be re-written.

5. **Should the planner also be the implementer by default?**
   *Proposed:* No. The handoff is explicit (section 10). If the user wants both, that is two sessions: one to plan, one to implement, with the plan file as the contract.

6. **Should plans be in a worktree?**
   *Proposed:* Out of scope for v1. The using-git-worktrees skill applies to feature work, not plan artifacts. Plans live in `docs/superpowers/plans/` in the main branch.

7. **Should the plan include a "Time estimate" field?**
   *Proposed:* No. Time estimates are the most common form of plan-debt. They get stale immediately. The plan says "what to do", not "how long it takes".

8. **Should the SKILL.md be split into SKILL.md + a `templates/` directory?**
   *Proposed:* No for v1. Keep the SKILL.md self-contained. Splitting is a v2-of-writing-plans concern.

## 15. Deliverables

When SP-3 starts, the deliverable is:

- `skills/writing-plans/SKILL.md` — rewritten to v2, 280-350 lines, replacing v1.
- `skills/writing-plans/visual-companion.md` — refreshed, includes the worked example from section 11.
- This spec (writing-plans v2 spec, already written).
- A short "principles cited" section at the top of the SKILL.md, listing the 4-6 principles from the Principles Library that apply to plan-writing (#1, #5, #6, #8, #9, #10 are the most likely candidates).

**Total: ~300 lines of SKILL.md + ~150 lines of visual-companion.md.** Roughly 2x v1, but the increase is in rigor, not verbosity.

## 16. References

- **Roadmap spec:** `docs/superpowers/specs/2026-06-12-vigilantes-methodology-roadmap.md`
- **Brainstorming v2 spec:** `docs/superpowers/specs/2026-06-12-brainstorming-v2.md` (the design-producer)
- **Principles Library spec:** `docs/superpowers/specs/2026-06-12-principles-library.md` (the shared vocabulary)
- **Rebrand spec:** `docs/superpowers/specs/2026-06-12-vigilantes-rebrand.md` (uses `vigilantes` naming)
- **TDD v1** (the test-pairing rule's source): `skills/test-driven-development/SKILL.md` (371 lines)
- **subagent-driven-development** (the research-dispatch rule's source): `skills/subagent-driven-development/SKILL.md`
- **using-git-worktrees** (referenced for plan worktree concerns, but plans themselves live in main): `skills/using-git-worktrees/SKILL.md`
- **v1 writing-plans** (the spec-replaced): `skills/writing-plans/SKILL.md` (152 lines)

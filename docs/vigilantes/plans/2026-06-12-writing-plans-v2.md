# writing-plans v2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `skills/writing-plans/SKILL.md` (v1, 152 lines) with v2 (280-350 lines) per the writing-plans v2 spec.

**Architecture:** Single SKILL.md file replacement. v2 reorganizes v1's 6 phases (scope check, subagent research, plan structure, bite-sized, self-review, handoff) into 8 phases (0-7), adds the principles audit at the top, adds risk-class-driven plan structure (low/medium/high templates), adds explicit rollback lines for non-reversible steps, adds test pairing for behavior changes, and cites the Principles Library. v2 ships after the Principles Library (SP-1) exists and Brainstorming v2 (SP-2) is in place — v2 consumes both as inputs.

**Tech Stack:** Plain markdown, no tooling required. Git for commits.

**Risk class:** Medium. The SKILL.md is the source of truth for how every Vigilantes plan gets written. Bad SKILL.md → bad plans → bad implementations. Self-review focuses on completeness (all 8 phases, all 3 risk-class templates, 10-item self-review, 4-criterion bite-sized definition) and on the 10-item acceptance test from the spec.

**Spec:** `docs/superpowers/specs/2026-06-12-writing-plans-v2.md`

**Depends on:** `docs/principles/` (SP-1) must exist. The v2 SKILL.md cites the library.

---

## Task 1: SKILL.md skeleton (frontmatter, principles cited, TOC)

**Files:**
- Modify: `skills/writing-plans/SKILL.md` (replaces v1 content; preserves file path)

- [ ] **Step 1: Read the spec and v1 to set context**

Read these files in full:
- `docs/superpowers/specs/2026-06-12-writing-plans-v2.md` (the source of truth for v2 content)
- `skills/writing-plans/SKILL.md` (v1, 152 lines, to identify which v1 patterns to preserve vs replace)
- `docs/principles/README.md` (the index of the 10 principles; v2 cites 4-6 of them)

**Verification:** You can summarize, in 1 sentence each, (a) the 8 phases of v2, (b) the 4-6 principles v2 cites, (c) the 3 v1 patterns v2 preserves.

- [ ] **Step 2: Replace the SKILL.md with the v2 skeleton**

Overwrite `skills/writing-plans/SKILL.md` with the following content. The skeleton is the frontmatter + principles-cited section + a table of contents with section placeholders that subsequent tasks will fill in. **Do not write the phase bodies yet** — those are Tasks 2-3.

```markdown
---
name: writing-plans
description: Use when you have a spec or design for a multi-step task, before touching implementation code. Produces a bite-sized, verifiable, testable plan an implementer can execute without asking the user any more questions.
---

# writing-plans v2

You are the planner. The user has approved a design. Your job is to convert that design into a **plan** — a sequence of bite-sized, verifiable steps an implementer (human or agent) can execute without further questions.

The planner's job ends at handoff. Implementation is a separate session.

## Principles cited in this skill

- **Look before you leap** — the design cited file:line; the plan keeps that discipline at the step level.
- **Make the implicit explicit** — 2-3 approaches are presented with explicit tradeoffs; the rejected alternatives are named.
- **Smallest reversible change** — steps are ordered by reversibility; non-reversible steps carry a rollback line.
- **Test the boundaries, not the path** — every behavior step has a paired test step; risky steps name failure modes.
- **Optimize for the next reader** — the plan is written for an implementer who has zero context.
- **Decide at the latest responsible moment** — non-trivial decisions are deferred to the latest step that can still make them.

(For the full principle definitions, see `docs/principles/README.md`.)

## The 8 phases

| # | Phase | Section |
|---|-------|---------|
| 0 | Risk-class confirmation | (filled in Task 2) |
| 1 | Design intake | (filled in Task 2) |
| 2 | Principles audit | (filled in Task 2) |
| 3 | Research dispatch | (filled in Task 2) |
| 4 | Plan structure selection | (filled in Task 2) |
| 5 | Step authoring | (filled in Task 3) |
| 6 | Self-review | (filled in Task 3) |
| 7 | User review gate | (filled in Task 3) |
| 8 | Handoff | (filled in Task 3) |

(The bite-sized definition, 10-item self-review, 3 risk-class templates, and 10 v1→v2 deltas are added in Tasks 4-6.)
```

- [ ] **Step 3: Verify the skeleton**

```bash
wc -l skills/writing-plans/SKILL.md
grep -c "^## " skills/writing-plans/SKILL.md
```

Expected: ~50 lines, 4-5 `##` sections (frontmatter is `---` not `##`, plus Principles cited, The 8 phases).

- [ ] **Step 4: Commit Task 1**

```bash
git add skills/writing-plans/SKILL.md
git commit -m "docs(skills): start writing-plans v2 rewrite (skeleton + principles cited)"
```

---

## Task 2: Write Phases 0-4 (intake, audit, structure selection)

**Files:**
- Modify: `skills/writing-plans/SKILL.md`

- [ ] **Step 1: Write Phase 0 (Risk-class confirmation)**

In `skills/writing-plans/SKILL.md`, replace this line in the TOC:

```
| 0 | Risk-class confirmation | (filled in Task 2) |
```

with:

```
| 0 | Risk-class confirmation | below |
```

Then add the Phase 0 body after the TOC. The content for Phase 0 is in **spec section 5** under "Phase 0 — Risk-class confirmation". The phase body should be ~30 lines covering:
- The 3 risk classes (low/medium/high) with examples
- The 30-second heuristic for assigning a class
- The "confirm with user" rule
- The depth-scaling rule (drives plan length and rigor)

**Verification:** the section names all 3 risk classes, gives an example of each, and states the depth-scaling rule.

- [ ] **Step 2: Write Phase 1 (Design intake)**

Replace the Phase 1 TOC entry, then add the Phase 1 body. The content is in **spec section 5** under "Phase 1 — Design intake". ~30 lines covering:
- The 3 places a design can live: brainstorming spec, design doc, chat message
- The "no design → Brainstorming v2 mini-pass" rule
- The "thin design → upgrade to one-pager first" rule
- Why the planner doesn't do design work

**Verification:** the section explicitly says "do not start writing a plan on a paragraph" and routes thin designs back to Brainstorming v2.

- [ ] **Step 3: Write Phase 2 (Principles audit)**

Replace the Phase 2 TOC entry, then add the Phase 2 body. The content is in **spec section 5** under "Phase 2 — Principles audit" and **spec section 8** (citation mechanism). ~30 lines covering:
- The 2-4 rule (cite 2-4 of the 10 library principles, not all 10)
- The audit format: "For this plan, the principles in play are X, Y, Z."
- The inline citation pattern: *"We extend `requestPasswordReset`, following *Smallest reversible change*."*
- The "leadership signal, not a checklist" framing

**Verification:** the section shows the audit format and the inline citation pattern with concrete examples.

- [ ] **Step 4: Write Phase 3 (Research dispatch)**

Replace the Phase 3 TOC entry, then add the Phase 3 body. The content is in **spec section 5** under "Phase 3 — Research dispatch" and references the `subagent-driven-development` skill. ~20 lines covering:
- The "research is a subagent's job" rule
- When to dispatch (only if research is needed)
- The handoff format: subagent returns research, planner consumes it
- The "do not inline research" anti-pattern

**Verification:** the section names the subagent-driven-development skill and explicitly says "the plan-writing session does not run the research."

- [ ] **Step 5: Write Phase 4 (Plan structure selection)**

Replace the Phase 4 TOC entry, then add the Phase 4 body. The content is in **spec section 5** under "Phase 4 — Plan structure selection" and **spec section 6** (the 3 risk-class structures). ~25 lines covering:
- The 3 structures: low (1-3 steps, ~20-50 lines), medium (4-10 steps, ~100-200 lines), high (10-15 steps, ~200-500 lines)
- The structure that matches the risk class
- The "templates are in section 6" pointer (the templates themselves go in Task 5)
- The "depth scales with risk" rule

**Verification:** the section names all 3 structures and their length ranges. Section 6 templates are referenced but the templates themselves are added in Task 5.

- [ ] **Step 6: Verify the size**

```bash
wc -l skills/writing-plans/SKILL.md
```

Expected: ≤ 200 lines at this point (skeleton ~50 + Phases 0-4 ~140 = ~190). If > 220, the phase bodies are too verbose — trim.

- [ ] **Step 7: Commit Task 2**

```bash
git add skills/writing-plans/SKILL.md
git commit -m "docs(skills): writing-plans v2 Phases 0-4 (intake, audit, structure selection)"
```

---

## Task 3: Write Phases 5-8 (authoring, self-review, user review, handoff)

**Files:**
- Modify: `skills/writing-plans/SKILL.md`

- [ ] **Step 1: Write Phase 5 (Step authoring)**

In `skills/writing-plans/SKILL.md`, replace the Phase 5 TOC entry, then add the Phase 5 body after Phase 4. The content is in **spec section 5** under "Phase 5 — Step authoring" and **spec section 5's step-body table** (Action, File path, Code, Verification, Rollback, Test pairing). ~50 lines covering:
- The 6-part step body table (which parts are conditional)
- The "complete code" rule (no `...`, no "implement here")
- The "verification line per step" rule
- The "rollback line for non-reversible steps" rule (with the "non-reversible" definition)
- The "test pairing for behavior changes" rule (test step first, TDD-style)
- The "code is the SKILL.md-shaped step body" framing

**Verification:** the section includes the full 6-part table with the "When" column showing which parts are conditional.

- [ ] **Step 2: Write Phase 6 (Self-review)**

Replace the Phase 6 TOC entry, then add the Phase 6 body. The content is in **spec section 5** under "Phase 6 — Self-review" and **spec section 9** (10-item checklist). The phase body says "the 10-item checklist is in section X below" and points to where the checklist itself is added in Task 4. ~15 lines covering:
- The "self-review runs before user review" rule
- The "any no blocks handoff; any kinda requires re-write" rule
- The "user is not the self-reviewer" rule
- Reference to the 10-item checklist (added in Task 4)

**Verification:** the section states the no/kinda rule and points forward to the checklist location.

- [ ] **Step 3: Write Phase 7 (User review gate)**

Replace the Phase 7 TOC entry, then add the Phase 7 body. The content is in **spec section 5** under "Phase 7 — User review gate". ~20 lines covering:
- The hard gate: do not start implementing without user approval
- "Looks good, continue" is approval; "let me think" is not
- The "present the plan, don't summarize it" rule
- The 3 approval outcomes: approve / change / abandon
- The "waivers are allowed; silent waivers are not" rule

**Verification:** the section names the 3 approval outcomes and the waiver rule.

- [ ] **Step 4: Write Phase 8 (Handoff)**

Replace the Phase 8 TOC entry, then add the Phase 8 body. The content is in **spec section 5** under "Phase 8 — Handoff" and **spec section 10** (handoff discipline). ~25 lines covering:
- The handoff path: `docs/superpowers/plans/YYYY-MM-DD-<task>.md`
- The 4-criterion completion: file saved, self-review passed, user approved, path returned
- The "planner does not implement" rule
- The "if the user asks the planner to implement, route to a new session" rule
- The "deviations update the plan file first" rule

**Verification:** the section names the handoff path and the 4-criterion completion rule.

- [ ] **Step 5: Update the TOC**

Update the TOC to replace all "filled in Task N" entries with "below" (or remove the column entirely).

**Verification:** `grep -c "filled in Task" skills/writing-plans/SKILL.md` returns 0.

- [ ] **Step 6: Verify the size**

```bash
wc -l skills/writing-plans/SKILL.md
```

Expected: ≤ 270 lines at this point (skeleton ~50 + Phases 0-4 ~140 + Phases 5-8 ~110 = ~300). Slightly over — Tasks 4-6 will add the supporting definitions, total should land in 280-350.

- [ ] **Step 7: Commit Task 3**

```bash
git add skills/writing-plans/SKILL.md
git commit -m "docs(skills): writing-plans v2 Phases 5-8 (authoring, self-review, user review, handoff)"
```

---

## Task 4: Add 4-criterion bite-sized definition + 10-item self-review checklist

**Files:**
- Modify: `skills/writing-plans/SKILL.md`

- [ ] **Step 1: Add the bite-sized definition section**

Append the following section to `skills/writing-plans/SKILL.md` (after Phase 8). The content is in **spec section 8** ("Bite-sized step — refined definition"). ~25 lines covering the 4 criteria:
1. One observable change (reviewable as a unit).
2. Executable in 2-5 minutes by a reader with the plan and the codebase.
3. Committable in isolation (commit message could summarize the step alone).
4. Independent (a failure in this step does not invalidate the success of any prior step).

Add a "When in doubt, split" callout. Reference Phase 5's step body table.

**Verification:** the section names all 4 criteria and the "when in doubt, split" rule.

- [ ] **Step 2: Add the 10-item self-review checklist**

Append the following section to `skills/writing-plans/SKILL.md` (after the bite-sized definition). The content is in **spec section 9** ("Self-review checklist (10 items)"). ~50 lines covering all 10 items verbatim:

1. Every step has code (no `...`, no "implement here", no "TBD").
2. Every step is bite-sized (all 4 criteria).
3. Every step has a verification line.
4. Every non-reversible step has a rollback line.
5. Every behavior change has a paired test step (TDD: test first, then implementation).
6. Steps are ordered by reversibility.
7. Principles cited at the top (2-4 of the 10).
8. Failure modes for risky steps are named (high-risk plans; medium-risk only for explicitly risky steps).
9. Exact file paths throughout.
10. No step depends on a prior step's undocumented state.

For each item, include a 1-line "what to look for" and a 1-line "the fix if it fails".

**Verification:** the section lists all 10 items, each with a "look for" + "fix" line.

- [ ] **Step 3: Verify the size**

```bash
wc -l skills/writing-plans/SKILL.md
```

Expected: ~340 lines. If > 350, trim verbose items in the checklist (the "look for" + "fix" lines are the most expandable).

- [ ] **Step 4: Commit Task 4**

```bash
git add skills/writing-plans/SKILL.md
git commit -m "docs(skills): writing-plans v2 bite-sized definition + 10-item self-review checklist"
```

---

## Task 5: Add the 3 risk-class-driven plan structure templates

**Files:**
- Modify: `skills/writing-plans/SKILL.md`

- [ ] **Step 1: Add the "Plan structure templates" section**

Append the following section to `skills/writing-plans/SKILL.md` (after the 10-item self-review). The content is in **spec section 6** (the 3 risk-class structures). ~80 lines covering all 3 templates:

**Low-risk template** (~20 lines): 1 section ("Step-by-step"), each step has file path + code + verification, no rollback or test pairing required.

**Medium-risk template** (~30 lines): 5 sections (Task, Files, Steps, Verification, Done), steps have code + verification + test pairing for behavior changes, principles cited inline.

**High-risk template** (~30 lines): 5 sections + Risk Register + Rollback Plan, steps have code + verification + rollback + test + inline principles, step ordering rationale (reversibility-driven).

**Verification:** all 3 templates are present and complete (each has its own `## <risk class>` heading). The high-risk template's Risk Register table has 4 columns: Risk, Likelihood, Impact, Mitigation.

- [ ] **Step 2: Verify the size**

```bash
wc -l skills/writing-plans/SKILL.md
```

Expected: 280-350 lines. The 3 templates add ~80 lines on top of the ~340 from Tasks 1-4. If > 350, the templates are too verbose — trim examples and keep the structure.

- [ ] **Step 3: Commit Task 5**

```bash
git add skills/writing-plans/SKILL.md
git commit -m "docs(skills): writing-plans v2 risk-class-driven plan structure templates (low/medium/high)"
```

---

## Task 6: Add the 10 v1 → v2 deltas table

**Files:**
- Modify: `skills/writing-plans/SKILL.md`

- [ ] **Step 1: Add the "What changed from v1" section**

Append the following section to `skills/writing-plans/SKILL.md` (after the templates). The content is in **spec section 4** (the 10 v1 → v2 deltas table). ~30 lines covering all 10 deltas:

| # | v1 | v2 | Why |
|---|---|---|---|
| 1 | "Scope check" — ask 1-2 questions. | Risk-class confirmation — confirm low/medium/high, drive plan depth from it. | Different risk classes need different artifacts. |
| 2 | No principles audit. | Phase 2: Principles audit — cite 2-4 of the 10 library principles. | Senior plans show their reasoning. |
| 3 | Subagent use is a side note. | Phase 3: Research dispatch — explicit: "dispatch subagents; do not inline research." | v1 had subagents in a separate skill; v2 makes the handoff explicit. |
| 4 | "Step-by-step" is one fixed section. | Risk-class-driven plan structure — 1/5/7 sections. | The plan should fit the work. |
| 5 | "Bite-sized" defined as 2-5 min. | 4-criterion definition: one observable change, 2-5 min, committable, independent. | 2-5 min is fuzzy; "one observable change" is testable. |
| 6 | Verification line per step. | Verification + rollback for non-reversible + test pairing for behavior changes. | v1 was optimistic; v2 plans for failure. |
| 7 | Self-review = 6 items. | Self-review = 10 items including reversibility ordering, principles cited, failure modes. | v1 checked completeness; v2 checks senior discipline. |
| 8 | Handoff is implicit. | Handoff is explicit — save to `docs/superpowers/plans/`, return path, do not implement. | Implicit handoffs slip. |
| 9 | "Done" = "test passes". | Done = all 5 sections complete, all verification lines run, all rollback lines tested, handoff signed. | Senior plans define done rigorously. |
| 10 | Plans can be inline (in chat). | Plans saved to files at a stable path. | Plans are artifacts; chat messages are not. |

**Verification:** the section includes all 10 rows of the delta table. The "Why" column is non-empty for every row.

- [ ] **Step 2: Verify the size**

```bash
wc -l skills/writing-plans/SKILL.md
```

Expected: 280-350 lines total. The deltas table adds ~30 lines on top of the ~340 from Tasks 1-5. If > 350, the deltas table can be slimmed (drop the "Why" column or shorten its content).

- [ ] **Step 3: Commit Task 6**

```bash
git add skills/writing-plans/SKILL.md
git commit -m "docs(skills): writing-plans v2 'what changed from v1' deltas table"
```

---

## Task 7: Update visual-companion.md with v2 worked example

**Files:**
- Modify: `skills/writing-plans/visual-companion.md`

- [ ] **Step 1: Read the existing visual-companion**

Read `skills/writing-plans/visual-companion.md` in full. Identify which v1 content is still relevant (the v1 templates, the v1 worked example) and which needs replacement.

- [ ] **Step 2: Add a v2 worked example**

The visual companion gets the long-form worked example. The SKILL.md stays under 350 lines; the visual companion absorbs the example depth.

Add a "v2 worked example" section to `skills/writing-plans/visual-companion.md` covering the same "reset password" feature from the Brainstorming v2 worked example, expanded to show:
- Phase 0: risk class = medium
- Phase 1: design intake (the brainstorming spec file path)
- Phase 2: principles audit (4 of the 10 cited)
- Phase 3: no subagent research needed (existing code is well-understood)
- Phase 4: medium-risk plan structure selected
- Phase 5: 8 step bodies, each with all 6 step-body parts (Action, File path, Code, Verification, Rollback, Test pairing)
- Phase 6: 10-item self-review passes
- Phase 7: user approves the plan
- Phase 8: handoff — saved to `docs/superpowers/plans/2026-06-12-reset-password.md`, path returned

The example should be ~150-200 lines. If the existing v1 visual companion is shorter, this is a substantial addition.

**Verification:** the visual companion has a "v2 worked example" section distinct from any v1 content. The 8 phases are visible in the example. Each step body shows all 6 parts (with the conditional ones marked).

- [ ] **Step 3: Commit Task 7**

```bash
git add skills/writing-plans/visual-companion.md
git commit -m "docs(skills): add v2 worked example to writing-plans visual companion"
```

---

## Task 8: Acceptance test + size cap verification

This task runs the 10-item acceptance test from **spec section 12** plus the 280-350 line cap from **spec section 7**.

- [ ] **Step 1: Check size cap**

```bash
wc -l skills/writing-plans/SKILL.md
```

Expected: 280-350 lines. If outside the range, fix the SKILL.md (trim or expand) before continuing.

- [ ] **Step 2: Check all 10 v1 → v2 deltas are present in the SKILL.md**

```bash
grep -c "^| [0-9]\+ |" skills/writing-plans/SKILL.md
```

Expected: 10 (one per delta in the deltas table). The scriptable check verifies the table exists; the manual review (Step 5 below) confirms all 10 are in the right format.

- [ ] **Step 3: Check all 8 phases are present**

```bash
grep -c "^## Phase " skills/writing-plans/SKILL.md
```

Expected: 8 (one per phase).

- [ ] **Step 4: Check the 10-item self-review is verbatim**

```bash
grep -c "^\([0-9]\+\\\. \|  - \[ \] \)" skills/writing-plans/SKILL.md
```

Expected: at least 10 (the 10 self-review items, plus possibly more in the bite-sized definition if it's also numbered).

- [ ] **Step 5: Check the 3 risk-class templates are present**

```bash
grep -c "^## .*-risk template\|^## Low-risk\|^## Medium-risk\|^## High-risk" skills/writing-plans/SKILL.md
```

Expected: 3 (one per risk class).

- [ ] **Step 6: Check the bite-sized definition has 4 criteria**

```bash
grep -c "^\([0-9]\+\\\. \|  - \[ \] \)" skills/writing-plans/SKILL.md
```

Expected: 4 in the bite-sized definition (matches the scriptable check in Step 4 if the definition uses a numbered list).

- [ ] **Step 7: Check the handoff discipline section**

```bash
grep -c "docs/superpowers/plans/" skills/writing-plans/SKILL.md
```

Expected: ≥ 1 (the handoff path is named in the SKILL.md).

- [ ] **Step 8: Run the side-by-side acceptance test (manual review)**

This is a **manual review** check, not a script. The implementer (or a reviewer) takes a real medium-risk task the user has done before (in v1 mode), plans it with v2, and confirms:
1. **(a) Plan is more rigorous** — rollback lines, test pairings, principles cited are all present.
2. **(b) Implementer can execute without asking the user** — every step has code, verification, file path.
3. **(c) Plan is reviewable in 5 minutes** — the size cap (≤350 lines) makes this feasible.

If any answer is "no", the SKILL.md has a gap. Fix the gap and re-run.

- [ ] **Step 9: Commit Task 8 (verification log)**

If all checks pass, the v2 SKILL.md is accepted. Commit a verification log.

```bash
cat > /tmp/writing-plans-v2-verification.md <<'EOF'
# writing-plans v2 Verification Log

Date: YYYY-MM-DD
Implementer: <name>
Spec: docs/superpowers/specs/2026-06-12-writing-plans-v2.md

| Check | Status | Notes |
|---|---|---|
| 1. Size 280-350 lines | PASS | <line count> |
| 2. 10 v1->v2 deltas | PASS | <evidence> |
| 3. 8 phases present | PASS | <evidence> |
| 4. 10-item self-review | PASS | <evidence> |
| 5. 3 risk-class templates | PASS | <evidence> |
| 6. 4-criterion bite-sized | PASS | <evidence> |
| 7. Handoff discipline | PASS | <evidence> |
| 8. Manual side-by-side test | PASS | <evidence> |
EOF

# Replace YYYY-MM-DD with today's date
sed -i "s/YYYY-MM-DD/$(date +%Y-%m-%d)/" /tmp/writing-plans-v2-verification.md
mv /tmp/writing-plans-v2-verification.md docs/superpowers/specs/2026-06-12-writing-plans-v2-VERIFICATION.md

git add docs/superpowers/specs/2026-06-12-writing-plans-v2-VERIFICATION.md
git commit -m "docs(skills): writing-plans v2 verification log"
```

---

## Self-Review

**1. Spec coverage:** The spec (`2026-06-12-writing-plans-v2.md` section 15) lists 4 deliverables: (1) v2 SKILL.md 280-350 lines, (2) refreshed `visual-companion.md` with worked example, (3) the spec itself (already written), (4) a "principles cited" section at the top of the SKILL.md. This plan covers (1) via Tasks 1-6, (2) via Task 7, (4) is inlined in Task 1. Coverage is complete.

**2. Placeholder scan:** No "TBD", "TODO", "implement later", or "fill in details" in the plan. Each step either (a) shows the content to write inline, (b) names the spec section to draw from, or (c) gives a concrete command. The phrase "filled in Task N" appears in the SKILL.md skeleton (Task 1) but those are explicit, scheduled placeholders in the SKILL.md being written, not in the plan. Pass.

**3. Type consistency:** The plan uses the same file paths throughout (`skills/writing-plans/SKILL.md`, `skills/writing-plans/visual-companion.md`, `docs/superpowers/specs/...`). The phase numbering (0-7) matches the spec. The 10 deltas match the spec's enumeration. The 10-item self-review matches the spec. Pass.

## Handoff

Plan complete and saved to `docs/superpowers/plans/2026-06-12-writing-plans-v2.md`. Two execution options:

1. **Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration
2. **Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?

**Dependency note:** SP-1 (Principles Library) must ship first; SP-2 (Brainstorming v2) should ship before SP-3 because the Brainstorming v2 SKILL.md is the source of "designs" that writing-plans v2 consumes in Phase 1 (Design intake). When SP-3 ships, the v2 SKILL.md can reference the Brainstorming v2 spec file by path, even if the Brainstorming v2 SKILL.md itself is still being polished. SP-3 doesn't strictly require SP-2 to be done — it requires that the v2 writing-plans skill knows where to find designs. The Principles Library (SP-1) is the hard prerequisite.

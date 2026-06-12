# Brainstorming v2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace `skills/brainstorming/SKILL.md` (v1, 164 lines) with v2 (280-350 lines) per the Brainstorming v2 spec.

**Architecture:** Single SKILL.md file replacement. v2 reorganizes v1's linear 9-item checklist into 11 phased sections (0-11), adds 7 new phases (Scope-risk profile, Data First, Stated-vs-real probe, Principles audit, Pushback, Tradeoff structure, Failure-mode pass), and cites 8 of the 10 Principles Library principles by name. v2 ships together with the Principles Library (SP-1) per open question 4 in the Brainstorming v2 spec — both must be ready before the v2 SKILL.md can cite the library.

**Tech Stack:** Plain markdown, no tooling required. Git for commits.

**Risk class:** Medium. The SKILL.md is content, not behavior, but it's the entry point for every Vigilantes change. A bad SKILL.md produces a junior agent on every brainstorm. Self-review focuses on completeness (all 11 phases present, all 10 anti-patterns, principles cited) and on the 7-checkpoint acceptance test from the spec.

**Spec:** `docs/superpowers/specs/2026-06-12-brainstorming-v2.md`

**Depends on:** `docs/principles/` must exist (SP-1 ships first; the v2 SKILL.md cites the library).

---

## Task 1: SKILL.md skeleton (frontmatter, principles cited, TOC)

**Files:**
- Modify: `skills/brainstorming/SKILL.md` (replaces v1 content; preserves file path)

- [ ] **Step 1: Read the spec and v1 to set context**

Read these files in full:
- `docs/superpowers/specs/2026-06-12-brainstorming-v2.md` (the source of truth for v2 content)
- `skills/brainstorming/SKILL.md` (v1, to identify which v1 patterns to preserve vs replace)
- `docs/principles/README.md` (the index of the 10 principles; v2 cites 8 of them)
- `skills/brainstorming/visual-companion.md` (to understand what visual-companion content currently exists)

**Verification:** You can summarize, in 1 sentence each, (a) the 11 phases of v2, (b) the 8 principles v2 cites, (c) the 3 v1 patterns v2 preserves.

- [ ] **Step 2: Replace the SKILL.md with the v2 skeleton**

Overwrite `skills/brainstorming/SKILL.md` with the following content. The skeleton is the frontmatter + principles-cited section + a table of contents with section placeholders that subsequent tasks will fill in. **Do not write the phase bodies yet** — those are Tasks 2-4.

```markdown
---
name: brainstorming
description: Use when the user is about to start a non-trivial change (new feature, behavior change, refactor) but has not yet produced a design or plan. Runs a phased senior-dev brainstorm that produces a design spec for the user to approve.
---

# Brainstorming v2

You are the senior engineer in the room. The user has brought a change request. Your job is to walk through a phased brainstorm and produce a **design spec** the user can approve before any code is written.

## Principles cited in this skill

- **Look before you leap** — read the codebase before asking the first clarifying question.
- **Distinguish signal from assumption** — name what's verified vs guessed.
- **Trace every claim** — every assertion cites a file:line or an explicit assumption.
- **Question the question** — probe the real problem behind the stated one.
- **Make the implicit explicit** — surface tradeoffs, constraints, assumptions.
- **Push back when warranted** — challenge respectfully with evidence.
- **Test the boundaries, not the path** — probe edge cases + failure modes.
- **Decide at the latest responsible moment** — delay commitment while keeping options open.

(For the full principle definitions, see `docs/principles/README.md`.)

## The 11 phases

| # | Phase | Section |
|---|-------|---------|
| 0 | Scope-risk profile | (filled in Task 2) |
| 1 | Data First | (filled in Task 2) |
| 2 | Stated vs real problem | (filled in Task 2) |
| 3 | Principles audit | (filled in Task 2) |
| 4 | Question taxonomy | (filled in Task 3) |
| 5 | Pushback when warranted | (filled in Task 3) |
| 6 | 2-3 approaches with tradeoffs | (filled in Task 3) |
| 7 | Failure-mode pass | (filled in Task 3) |
| 8 | Design presentation | (filled in Task 4) |
| 9 | Spec write + self-review | (filled in Task 4) |
| 10 | User review gate | (filled in Task 4) |
| 11 | Transition to writing-plans | (filled in Task 4) |

(The 10 anti-patterns section is added in Task 5.)
```

- [ ] **Step 3: Verify the skeleton**

```bash
wc -l skills/brainstorming/SKILL.md
grep -c "^## " skills/brainstorming/SKILL.md
```

Expected: ~45 lines, 4-5 `##` sections (frontmatter is `---` not `##`, plus Principles cited, The 11 phases).

- [ ] **Step 4: Commit Task 1**

```bash
git add skills/brainstorming/SKILL.md
git commit -m "docs(skills): start brainstorming v2 rewrite (skeleton + principles cited)"
```

---

## Task 2: Write Phases 0-3 (setup, research, framing)

**Files:**
- Modify: `skills/brainstorming/SKILL.md` (replace "filled in Task 2" placeholders with real phase content)

- [ ] **Step 1: Write Phase 0 (Scope-risk profile)**

In `skills/brainstorming/SKILL.md`, replace this line in the TOC:

```
| 0 | Scope-risk profile | (filled in Task 2) |
```

with:

```
| 0 | Scope-risk profile | below |
```

Then add the Phase 0 section after the TOC. The content for Phase 0 is defined in **spec section 4** under "Phase 0 — Scope-risk profile". The phase body should be ~30 lines covering:
- What the risk class is (low/medium/high)
- 30-second heuristic for assigning a class
- How the class drives the depth of later phases
- The "low-risk bypass" — when to skip the full process

**Verification:** the section is present, mentions all three risk classes, and references the spec section for definitions.

- [ ] **Step 2: Write Phase 1 (Data First)**

Replace the Phase 1 TOC entry, then add the Phase 1 body after Phase 0. The content is in **spec section 4** under "Phase 1 — Data First". The phase body should be ~40 lines covering:
- The "ask second, read first" rule
- What to read (codebase, data model, related code, tests)
- The "every claim cites a file:line" discipline
- Examples of good vs bad Data First outputs (cite spec section 9 for the worked example)

**Verification:** the section explicitly forbids "let me ask a few questions to understand the codebase" (it's the #1 anti-pattern).

- [ ] **Step 3: Write Phase 2 (Stated vs real problem)**

Replace the Phase 2 TOC entry, then add the Phase 2 body. Content is in **spec section 4** under "Phase 2 — Stated vs real problem probe". ~25 lines covering:
- The principle: users describe solutions, not problems
- The probe question: "what problem does this solve for you?"
- The 2-3 sub-probes: who has the problem, how often, what's the workaround

**Verification:** the section includes at least one example probe question and one example "real problem vs stated problem" reframing.

- [ ] **Step 4: Write Phase 3 (Principles audit)**

Replace the Phase 3 TOC entry, then add the Phase 3 body. Content is in **spec section 4** under "Phase 3 — Principles audit". ~25 lines covering:
- The 8 principles v2 cites (named at top of SKILL.md)
- The audit format: "For this change, the principles in play are X, Y, Z"
- The 2-4 rule (not all 10)
- The principle-name citation pattern: *"We extend `requestPasswordReset`, following *Smallest reversible change*."*

**Verification:** the section names each of the 8 cited principles, shows the audit format, and shows the inline citation pattern.

- [ ] **Step 5: Verify the size**

```bash
wc -l skills/brainstorming/SKILL.md
```

Expected: ≤ 170 lines at this point (skeleton ~45 + Phases 0-3 ~120 = ~165). If it's > 200, the phase bodies are too verbose — trim before continuing.

- [ ] **Step 6: Commit Task 2**

```bash
git add skills/brainstorming/SKILL.md
git commit -m "docs(skills): brainstorming v2 Phases 0-3 (scope-risk, data first, stated-vs-real, principles audit)"
```

---

## Task 3: Write Phases 4-7 (questions, pushback, approaches, failure modes)

**Files:**
- Modify: `skills/brainstorming/SKILL.md`

- [ ] **Step 1: Write Phase 4 (Question taxonomy)**

In `skills/brainstorming/SKILL.md`, replace the Phase 4 TOC entry, then add the Phase 4 body after Phase 3. Content is in **spec section 4** under "Phase 4 — Question taxonomy" and the spec's **open question 1** ("Question-type state implicit or explicit? — Proposed: implicit"). ~35 lines covering:
- The 5 question types: fact-finding, constraint, decision, tradeoff, clarification
- When to use each (with examples)
- The efficiency rule: <7 clarifying questions total per brainstorm
- The "implicit state" decision: the agent doesn't track question types in a structured way; it just chooses the right one for the moment

**Verification:** the section names all 5 question types, gives an example of each, and mentions the <7-questions rule.

- [ ] **Step 2: Write Phase 5 (Pushback when warranted)**

Replace the Phase 5 TOC entry, add the Phase 5 body. Content is in **spec section 4** under "Phase 5 — Pushback when warranted" and **spec section 4.7** (Push back when warranted principle). ~40 lines covering:
- The 4-step pattern: name concern → cite evidence → propose alternative → defer to user
- When to push back (clear issues with evidence)
- When NOT to push back (user has more context, or it's a stylistic preference)
- Examples of calibrated pushback vs yes-man vs contrarian

**Verification:** the section includes the 4-step pattern verbatim and at least 2 examples.

- [ ] **Step 3: Write Phase 6 (2-3 approaches with tradeoffs)**

Replace the Phase 6 TOC entry, add the Phase 6 body. Content is in **spec section 4** under "Phase 6 — 2-3 approaches with tradeoffs". ~45 lines covering:
- The "always 2-3 options" rule (not 1, not 5)
- The tradeoff structure: pros / cons / cost / risk / recommendation
- The "Decide at the latest responsible moment" tie-breaker for the recommendation
- The "Make the implicit explicit" principle: name the rejected alternative and why

**Verification:** the section shows the full tradeoff structure (5 columns) and ties the recommendation to principle #10.

- [ ] **Step 4: Write Phase 7 (Failure-mode pass)**

Replace the Phase 7 TOC entry, add the Phase 7 body. Content is in **spec section 4** under "Phase 7 — Failure-mode pass" and **spec section 4.8** (Test the boundaries principle). ~50 lines covering:
- The 10 failure-mode categories: empty input, boundaries, concurrency, auth, injection, sensitive data, performance, backwards compat, reversibility, observability
- The 1-line description of each
- The "≥3 probes" rule (acceptance test item)
- The waiver mechanism: user can waive a category, but the waiver goes in the spec, not in the chat

**Verification:** the section lists all 10 categories with their 1-line descriptions, and the waiver rule is explicit.

- [ ] **Step 5: Verify the size**

```bash
wc -l skills/brainstorming/SKILL.md
```

Expected: ≤ 280 lines. If it's > 300, the phase bodies are too verbose — trim.

- [ ] **Step 6: Commit Task 3**

```bash
git add skills/brainstorming/SKILL.md
git commit -m "docs(skills): brainstorming v2 Phases 4-7 (questions, pushback, approaches, failure modes)"
```

---

## Task 4: Write Phases 8-11 (design, spec, review, handoff)

**Files:**
- Modify: `skills/brainstorming/SKILL.md`

- [ ] **Step 1: Write Phase 8 (Design presentation)**

In `skills/brainstorming/SKILL.md`, replace the Phase 8 TOC entry, then add the Phase 8 body after Phase 7. Content is in **spec section 4** under "Phase 8 — Design presentation". ~25 lines covering:
- The "present design, don't dump it" rule
- The structure: problem restatement → principles in play → chosen approach + why → 2-3 rejected approaches → failure modes addressed → open questions
- The inline principle citation (continues from Phase 3)
- What NOT to include (no code, no implementation details — those go in writing-plans)

**Verification:** the section names the 6 components of a design presentation and explicitly says "no code".

- [ ] **Step 2: Write Phase 9 (Spec write + self-review)**

Replace the Phase 9 TOC entry, add the Phase 9 body. Content is in **spec section 4** under "Phase 9 — Spec write + self-review" and the spec's **5-item self-review checklist**. ~30 lines covering:
- Where the spec lives: `docs/superpowers/specs/YYYY-MM-DD-<feature>.md`
- The spec template (covered by the spec itself — link to the spec for the template, don't duplicate)
- The self-review checklist: (1) every claim traceable? (2) principles cited? (3) failure modes addressed? (4) 2-3 approaches considered? (5) pushback applied where warranted?
- The "no placeholders" rule (links to writing-plans v1's rule)

**Verification:** the section lists all 5 self-review items and names the spec file path.

- [ ] **Step 3: Write Phase 10 (User review gate)**

Replace the Phase 10 TOC entry, add the Phase 10 body. Content is in **spec section 4** under "Phase 10 — User review gate" (preserved from v1, with the v2 addition of a "review the design, not the prose" framing). ~20 lines covering:
- The hard gate: do not proceed to writing-plans without user approval
- What the user is reviewing: the design choices, not the prose
- How to handle "this is too simple, just build it": route to writing-plans with a low-risk class, do not skip the design entirely
- The "approve, change, or abandon" three options

**Verification:** the section names the three approval outcomes and explicitly says do not skip the design.

- [ ] **Step 4: Write Phase 11 (Transition to writing-plans)**

Replace the Phase 11 TOC entry, add the Phase 11 body. Content is in **spec section 4** under "Phase 11 — Transition to writing-plans" (terminal state, preserved from v1). ~15 lines covering:
- The handoff: spec file path + design summary + risk class
- The user's role in the transition: confirm risk class, then start a new session for writing-plans
- Why two sessions: design review and plan execution are different concerns
- Reference to `skills/writing-plans/SKILL.md` (v1, 152 lines) for the next-step protocol

**Verification:** the section is brief (~15 lines), names the writing-plans handoff, and references the writing-plans skill by name.

- [ ] **Step 5: Update the TOC**

Update the TOC to replace all "filled in Task N" entries with "below" (or remove the column entirely). The TOC at this point should be a clean reference.

**Verification:** `grep -c "filled in Task" skills/brainstorming/SKILL.md` returns 0.

- [ ] **Step 6: Verify the size**

```bash
wc -l skills/brainstorming/SKILL.md
```

Expected: 280-350 lines per the spec's cap. If < 280, some phase body is too thin — flesh out. If > 350, trim verbose phases.

- [ ] **Step 7: Commit Task 4**

```bash
git add skills/brainstorming/SKILL.md
git commit -m "docs(skills): brainstorming v2 Phases 8-11 (design, spec, review, handoff)"
```

---

## Task 5: Add the 10 anti-patterns section

**Files:**
- Modify: `skills/brainstorming/SKILL.md`

- [ ] **Step 1: Add the "Anti-patterns" section**

Append the following section to `skills/brainstorming/SKILL.md` (after Phase 11). The 10 anti-patterns are listed in **spec section 5** under "The 10 anti-patterns". Each anti-pattern is a sentence the agent might say, paired with the correct behavior. ~50 lines covering all 10.

For each anti-pattern, the SKILL.md should show:
- The bad sentence (what the agent might say)
- Why it's bad (which principle it violates)
- The correct behavior

The 10 anti-patterns:
1. "Let me ask a few questions to understand the codebase." — Read first, ask second.
2. "Great idea, let's do that!" — Push back when warranted, don't yes-man.
3. "I assume the system does X." — Cite a file, or mark as assumption explicitly.
4. "I cited all 10 principles." — 2-4 is the right number, not 10.
5. "This is too simple to need a design." — A typo doesn't, but anything multi-step does.
6. "I have 12 clarifying questions." — Cap at <7. If you need more, you didn't read first.
7. "Here's a 5-option menu." — 2-3 is the right number. More = decision paralysis.
8. "I'm not sure about the failure modes." — Run the 10-category pass. "Not sure" is itself a probe.
9. "Let me start writing the plan." — Wait for spec approval. The hard gate is hard.
10. "I'll just add a small thing while I'm in there." — Scope creep. Note in the spec, ship separately.

**Verification:** the section lists all 10 anti-patterns, each with a bad sentence + correct behavior.

- [ ] **Step 2: Verify the size**

```bash
wc -l skills/brainstorming/SKILL.md
```

Expected: 280-350 lines total. The anti-patterns section adds ~50 lines on top of the ~280-300 lines from Tasks 2-4. If > 350, trim verbose explanations.

- [ ] **Step 3: Commit Task 5**

```bash
git add skills/brainstorming/SKILL.md
git commit -m "docs(skills): brainstorming v2 anti-patterns section (10 callouts)"
```

---

## Task 6: Update visual-companion.md

**Files:**
- Modify: `skills/brainstorming/visual-companion.md`

- [ ] **Step 1: Read the existing visual-companion**

Read `skills/brainstorming/visual-companion.md` in full. Identify which v1 sections are still relevant (e.g., the v1 worked example) and which need replacement.

- [ ] **Step 2: Add a v2 worked example**

Per **open question 2** in the Brainstorming v2 spec ("Worked example in SKILL.md or visual-companion.md? — Proposed: 1 short in SKILL.md"), the SKILL.md has 1 short example (already inlined in Phase 6 if you followed spec section 9). The visual companion gets the longer worked example.

Add a "v2 worked example" section to `skills/brainstorming/visual-companion.md` covering the same "reset password" example from spec section 9, expanded to show:
- Phase 0 (low/medium/high: this is medium)
- Phase 1 (the 3 files read with file:line citations)
- Phase 2 (real problem: "users forget passwords and contact support" vs stated: "add reset button")
- Phase 3 (3-4 principles cited: #1, #4, #5, #6)
- Phase 4-7 (questions, pushback, 2 approaches with tradeoffs, 5 failure modes named)
- Phase 8-10 (design presented, spec written, user approved)

The example should be ~150-200 lines. If the existing v1 visual companion is shorter, this is a substantial addition.

**Verification:** the visual companion has a "v2 worked example" section distinct from any v1 content. The 11 phases are visible in the example.

- [ ] **Step 3: Commit Task 6**

```bash
git add skills/brainstorming/visual-companion.md
git commit -m "docs(skills): add v2 worked example to brainstorming visual companion"
```

---

## Task 7: Acceptance test + size cap verification

This task runs the 7-item acceptance test from **spec section 11** plus the 280-350 line cap from **spec section 7**.

- [ ] **Step 1: Check size cap**

```bash
wc -l skills/brainstorming/SKILL.md
```

Expected: 280-350 lines. If outside the range, fix the SKILL.md (trim or expand) before continuing.

- [ ] **Step 2: Check all 11 phases are present**

```bash
grep -c "^## Phase " skills/brainstorming/SKILL.md
```

Expected: 11 (one per phase).

- [ ] **Step 3: Check 10 anti-patterns are present**

```bash
grep -c "^\([0-9]\{1,2\}\\\. \|  - \"\)" skills/brainstorming/SKILL.md
# or alternatively, count the anti-pattern markers
grep -c "Anti-pattern\|anti-pattern" skills/brainstorming/SKILL.md
```

Expected: anti-patterns section has 10 distinct entries.

- [ ] **Step 4: Check principles cited in the SKILL.md**

```bash
grep -c "Look before you leap" skills/brainstorming/SKILL.md
grep -c "Distinguish signal from assumption" skills/brainstorming/SKILL.md
grep -c "Trace every claim" skills/brainstorming/SKILL.md
grep -c "Question the question" skills/brainstorming/SKILL.md
grep -c "Make the implicit explicit" skills/brainstorming/SKILL.md
grep -c "Push back when warranted" skills/brainstorming/SKILL.md
grep -c "Test the boundaries, not the path" skills/brainstorming/SKILL.md
grep -c "Decide at the latest responsible moment" skills/brainstorming/SKILL.md
```

Expected: each command returns ≥ 1. The 8 principles v2 cites should appear at minimum in the "Principles cited" section at the top of the SKILL.md.

- [ ] **Step 5: Run the 7-checkpoint acceptance test (manual review)**

This is a **manual review** check, not a script. The implementer (or a reviewer) picks a real tricky prompt (e.g., the "reset password" worked example) and runs through the v2 SKILL.md mentally, asking:

1. **Senior feel?** Does the SKILL.md produce output that reads as a senior engineer, not a checklist?
2. **Every claim traceable to file?** Does the worked example show file:line citations?
3. **2+ principles cited?** Does the worked example show 2-4 principles, not all 10?
4. **Pushback happened if warranted?** Does the worked example show the 4-step pattern in action?
5. **Failure-mode pass produced ≥3 probes?** Does the worked example show 3+ failure modes from the 10-category list?
6. **Spec written + approved?** Does the SKILL.md enforce the hard gate at Phase 10?
7. **<7 questions asked?** Does the worked example show ≤7 clarifying questions?

If any answer is "no", the SKILL.md has a gap. Fix the gap (in the SKILL.md or the worked example in visual-companion.md) and re-run the test.

- [ ] **Step 6: Commit Task 7 (verification log)**

If all checks pass, the v2 SKILL.md is accepted. Commit a verification log.

```bash
cat > /tmp/brainstorming-v2-verification.md <<'EOF'
# Brainstorming v2 Verification Log

Date: YYYY-MM-DD
Implementer: <name>
Spec: docs/superpowers/specs/2026-06-12-brainstorming-v2.md

| Check | Status | Notes |
|---|---|---|
| 1. Size 280-350 lines | PASS | <line count> |
| 2. All 11 phases present | PASS | <evidence> |
| 3. 10 anti-patterns | PASS | <evidence> |
| 4. 8 principles cited | PASS | <evidence> |
| 5. Manual 7-checkpoint test | PASS | <evidence> |
EOF

# Replace YYYY-MM-DD with today's date
sed -i "s/YYYY-MM-DD/$(date +%Y-%m-%d)/" /tmp/brainstorming-v2-verification.md
mv /tmp/brainstorming-v2-verification.md docs/superpowers/specs/2026-06-12-brainstorming-v2-VERIFICATION.md

git add docs/superpowers/specs/2026-06-12-brainstorming-v2-VERIFICATION.md
git commit -m "docs(skills): brainstorming v2 verification log"
```

---

## Self-Review

**1. Spec coverage:** The spec (`2026-06-12-brainstorming-v2.md` section 7) lists 5 deliverables: (1) v2 SKILL.md 280-350 lines, (2) v2 visual-companion.md updated, (3) the spec itself (already written), (4) the spec acceptance test passes, (5) verification log. This plan covers (1) via Tasks 1-5, (2) via Task 6, (4) and (5) via Task 7. Coverage is complete.

**2. Placeholder scan:** No "TBD", "TODO", "implement later", or "fill in details" in the plan. Each step either (a) shows the content to write inline, (b) names the spec section to draw from, or (c) gives a concrete command. The phrase "filled in Task N" appears in the SKILL.md skeleton (Task 1) but those are not placeholders in the *plan* — they're explicit placeholders in the *SKILL.md being written*, scheduled for replacement in Tasks 2-4. Pass.

**3. Type consistency:** The plan uses the same file paths throughout (`skills/brainstorming/SKILL.md`, `skills/brainstorming/visual-companion.md`, `docs/superpowers/specs/...`). The phase numbering (0-11) matches the spec. The 10 anti-patterns match the spec's enumeration. Pass.

## Handoff

Plan complete and saved to `docs/superpowers/plans/2026-06-12-brainstorming-v2.md`. Two execution options:

1. **Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration
2. **Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?

**Dependency note:** SP-1 (Principles Library) ships first. The v2 SKILL.md cites `docs/principles/README.md` in its "Principles cited" section. If SP-1 has not shipped, the v2 SKILL.md is incomplete — its principles section points to a non-existent file. Run SP-1 first; this plan assumes the library exists.

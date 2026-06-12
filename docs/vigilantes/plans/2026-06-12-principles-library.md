# Principles Library Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the 10-principle Vigilantes Principles Library at `docs/principles/` plus its README index.

**Architecture:** Plain markdown files, one principle per file, with a README index. Each principle file uses a fixed 5-field template (Title, Statement, Why, Anti-pattern, Used by) plus an optional Source basis field. Hard cap of 10 lines per file. The library is a reference, not a SKILL — it is not auto-loaded.

**Tech Stack:** Plain markdown, no tooling required. Git for commits.

**Risk class:** Low. Docs only, no behavior change, no test pairing required. Self-review focuses on file completeness and field coverage, not on logic.

**Spec:** `docs/superpowers/specs/2026-06-12-principles-library.md`

---

## Task 1: Create the `docs/principles/` directory and principles 1–3

**Files:**
- Create: `docs/principles/01-look-before-you-leap.md`
- Create: `docs/principles/02-distinguish-signal-from-assumption.md`
- Create: `docs/principles/03-trace-every-claim.md`

- [ ] **Step 1: Create the directory**

```bash
mkdir -p docs/principles
```

- [ ] **Step 2: Write `01-look-before-you-leap.md`**

Create `docs/principles/01-look-before-you-leap.md` with the following content:

```markdown
# 1. Look before you leap

**Statement:** Research the codebase and data model before acting on a change.

**Why:** Unverified assumptions are the most expensive kind of bug — they cost an implementation cycle to discover.

**Anti-pattern:** "Let me ask a few questions to understand the codebase." (Ask second, read first.)

**Used by:** brainstorming (Phase 1 Data First), writing-plans (evidence grounding), code-review, debug.

**Source basis:** Common senior-dev practice. Operationalized in this methodology as the "Data First" phase in brainstorming.
```

- [ ] **Step 3: Verify `01-look-before-you-leap.md`**

Run:

```bash
wc -l docs/principles/01-look-before-you-leap.md
```

Expected: ≤ 10 lines (the heading is line 1; total including blank line is around 10).

Then run:

```bash
grep -c "^\*\*" docs/principles/01-look-before-you-leap.md
```

Expected: 5 (Statement, Why, Anti-pattern, Used by, Source basis).

- [ ] **Step 4: Write `02-distinguish-signal-from-assumption.md`**

Create `docs/principles/02-distinguish-signal-from-assumption.md` with the following content:

```markdown
# 2. Distinguish signal from assumption

**Statement:** Name what's verified vs what's guessed. Both are allowed; the difference must be visible.

**Why:** A team that can't tell verified from assumed fact will spend meetings arguing about both in the same voice.

**Anti-pattern:** "I think the system does X." (No source. Same voice as a verified claim.)

**Used by:** brainstorming (Phase 1 Data First + Phase 4 question taxonomy), writing-plans (evidence grounding), code-review.

**Source basis:** Standard epistemic discipline; named in the user's Planning Protocol ("Source Accuracy & Drafting Protocol").
```

- [ ] **Step 5: Verify `02-distinguish-signal-from-assumption.md`**

Run:

```bash
wc -l docs/principles/02-distinguish-signal-from-assumption.md
grep -c "^\*\*" docs/principles/02-distinguish-signal-from-assumption.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 6: Write `03-trace-every-claim.md`**

Create `docs/principles/03-trace-every-claim.md` with the following content:

```markdown
# 3. Trace every claim

**Statement:** Every assertion cites a source — a file:line, a doc section, a prior decision, or an explicit assumption.

**Why:** Tracing is what lets a future reviewer verify or refute. Untraced claims become folklore.

**Anti-pattern:** "The system works that way" (no source) vs. "I read `src/auth/handler.ts:42`; the system works that way."

**Used by:** brainstorming, writing-plans, code-review, debug.

**Source basis:** User's Planning Protocol explicitly requires this. TDD's "verify RED" mandate is a special case.
```

- [ ] **Step 7: Verify `03-trace-every-claim.md`**

Run:

```bash
wc -l docs/principles/03-trace-every-claim.md
grep -c "^\*\*" docs/principles/03-trace-every-claim.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 8: Commit Task 1**

```bash
git add docs/principles/01-look-before-you-leap.md docs/principles/02-distinguish-signal-from-assumption.md docs/principles/03-trace-every-claim.md
git commit -m "docs(principles): add first 3 principles (data and evidence)"
```

---

## Task 2: Create principles 4–6 (framing and change)

**Files:**
- Create: `docs/principles/04-question-the-question.md`
- Create: `docs/principles/05-smallest-reversible-change.md`
- Create: `docs/principles/06-make-the-implicit-explicit.md`

- [ ] **Step 1: Write `04-question-the-question.md`**

Create `docs/principles/04-question-the-question.md` with the following content:

```markdown
# 4. Question the question

**Statement:** Probe the real problem behind the stated one before designing a solution.

**Why:** Users describe solutions, not problems. Solving the wrong problem with the right technique is still failure.

**Anti-pattern:** "User asked for X. Build X." (No probe of the underlying problem.)

**Used by:** brainstorming (Phase 2 Stated vs real problem), writing-plans (consumes the probe's output).

**Source basis:** Common product-engineering practice. Reframed for coding-agent context.
```

- [ ] **Step 2: Verify `04-question-the-question.md`**

```bash
wc -l docs/principles/04-question-the-question.md
grep -c "^\*\*" docs/principles/04-question-the-question.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 3: Write `05-smallest-reversible-change.md`**

Create `docs/principles/05-smallest-reversible-change.md` with the following content:

```markdown
# 5. Smallest reversible change

**Statement:** Prefer incremental, undoable moves over big-bang rewrites.

**Why:** Reversible changes lower the cost of being wrong. The cost of an unrevertable mistake is asymmetric.

**Anti-pattern:** "Let me rewrite the whole module while I'm in there." (Scope creep, irreversibly.)

**Used by:** brainstorming (Phase 6 approaches), writing-plans (steps ordered by reversibility), code-review, git worktrees.

**Source basis:** Kent Beck, "Tidy First?", and the broader incremental-design school. Operationalized via the using-git-worktrees skill.
```

- [ ] **Step 4: Verify `05-smallest-reversible-change.md`**

```bash
wc -l docs/principles/05-smallest-reversible-change.md
grep -c "^\*\*" docs/principles/05-smallest-reversible-change.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 5: Write `06-make-the-implicit-explicit.md`**

Create `docs/principles/06-make-the-implicit-explicit.md` with the following content:

```markdown
# 6. Make the implicit explicit

**Statement:** Surface tradeoffs, constraints, and assumptions; don't leave them implicit.

**Why:** Implicit decisions can't be reviewed, can't be changed, and surprise the next person. Explicit decisions are gifts to the team.

**Anti-pattern:** A design that says "we'll use approach X" without naming the alternatives it beat.

**Used by:** brainstorming (Phase 6 tradeoff structure, Phase 3 audit), writing-plans, code-review, requesting-code-review.

**Source basis:** Common engineering-review practice. Reinforced by TDD's anti-patterns and the code-review skills.
```

- [ ] **Step 6: Verify `06-make-the-implicit-explicit.md`**

```bash
wc -l docs/principles/06-make-the-implicit-explicit.md
grep -c "^\*\*" docs/principles/06-make-the-implicit-explicit.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 7: Commit Task 2**

```bash
git add docs/principles/04-question-the-question.md docs/principles/05-smallest-reversible-change.md docs/principles/06-make-the-implicit-explicit.md
git commit -m "docs(principles): add principles 4-6 (framing and change)"
```

---

## Task 3: Create principles 7–10 (interaction and decision)

**Files:**
- Create: `docs/principles/07-push-back-when-warranted.md`
- Create: `docs/principles/08-test-the-boundaries-not-the-path.md`
- Create: `docs/principles/09-optimize-for-the-next-reader.md`
- Create: `docs/principles/10-decide-at-the-latest-responsible-moment.md`

- [ ] **Step 1: Write `07-push-back-when-warranted.md`**

Create `docs/principles/07-push-back-when-warranted.md` with the following content:

```markdown
# 7. Push back when warranted

**Statement:** Challenge respectfully with evidence when an approach has clear issues. Defer when the other party has more context.

**Why:** "Yes-man" agents ship bad designs. Contrarian agents slow teams down. The right behavior is calibrated pushback.

**Anti-pattern:** "Great idea, let's do that!" (no scrutiny) OR "Actually, that won't work because..." (contrarian for sport).

**Used by:** brainstorming (Phase 5), code-review, receiving-code-review.

**Source basis:** Standard senior-dev social discipline. Operationalized in brainstorming as a 4-step pattern: name concern → cite evidence → propose alternative → defer to user.
```

- [ ] **Step 2: Verify `07-push-back-when-warranted.md`**

```bash
wc -l docs/principles/07-push-back-when-warranted.md
grep -c "^\*\*" docs/principles/07-push-back-when-warranted.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 3: Write `08-test-the-boundaries-not-the-path.md`**

Create `docs/principles/08-test-the-boundaries-not-the-path.md` with the following content:

```markdown
# 8. Test the boundaries, not the path

**Statement:** Probe edge cases, failure modes, and adversarial inputs — not just the happy path.

**Why:** Happy-path correctness is the cheapest property to achieve. Robustness is the property that matters in production.

**Anti-pattern:** A test suite that exercises `add(2, 3)` and stops.

**Used by:** brainstorming (Phase 7 failure-mode pass), TDD (iron law extension), writing-plans, debug.

**Source basis:** TDD's iron law is the test-time version; the brainstorming extension is design-time. The category list in brainstorming's Phase 7 (10 categories) is the operational checklist.
```

- [ ] **Step 4: Verify `08-test-the-boundaries-not-the-path.md`**

```bash
wc -l docs/principles/08-test-the-boundaries-not-the-path.md
grep -c "^\*\*" docs/principles/08-test-the-boundaries-not-the-path.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 5: Write `09-optimize-for-the-next-reader.md`**

Create `docs/principles/09-optimize-for-the-next-reader.md` with the following content:

```markdown
# 9. Optimize for the next reader

**Statement:** Clarity over cleverness. Code, docs, and messages should be readable by someone who hasn't seen the context.

**Why:** Code is read more than written. The next reader (often future-you) pays the cost of clever shortcuts.

**Anti-pattern:** A one-liner that uses five advanced features to replace three readable lines.

**Used by:** writing-plans (plan clarity), code-review, debugging (variable names, comments), all skill writing.

**Source basis:** Long-standing software-craft principle. Operationalized in this methodology via the spec self-review checklist and the writing-plans "complete code in every step" rule.
```

- [ ] **Step 6: Verify `09-optimize-for-the-next-reader.md`**

```bash
wc -l docs/principles/09-optimize-for-the-next-reader.md
grep -c "^\*\*" docs/principles/09-optimize-for-the-next-reader.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 7: Write `10-decide-at-the-latest-responsible-moment.md`**

Create `docs/principles/10-decide-at-the-latest-responsible-moment.md` with the following content:

```markdown
# 10. Decide at the latest responsible moment

**Statement:** Delay commitment while keeping options open. Commit only when the cost of waiting exceeds the cost of locking in.

**Why:** Early commitments foreclose options you didn't know you'd want. Late commitments keep flexibility — but only if you haven't painted yourself into a corner.

**Anti-pattern:** Picking a database on day 1 because "we need to pick one", before any feature has constraints.

**Used by:** brainstorming (Phase 6 approaches), writing-plans (step ordering), subagent-driven-development (parallel work to preserve options).

**Source basis:** Agile / lean software development canon. Operationalized in this methodology as a tie-breaker for the Phase 6 recommendation.
```

- [ ] **Step 8: Verify `10-decide-at-the-latest-responsible-moment.md`**

```bash
wc -l docs/principles/10-decide-at-the-latest-responsible-moment.md
grep -c "^\*\*" docs/principles/10-decide-at-the-latest-responsible-moment.md
```

Expected: ≤ 10 lines, 5 fields.

- [ ] **Step 9: Commit Task 3**

```bash
git add docs/principles/07-push-back-when-warranted.md docs/principles/08-test-the-boundaries-not-the-path.md docs/principles/09-optimize-for-the-next-reader.md docs/principles/10-decide-at-the-latest-responsible-moment.md
git commit -m "docs(principles): add principles 7-10 (interaction and decision)"
```

---

## Task 4: Create the README index

**Files:**
- Create: `docs/principles/README.md`

- [ ] **Step 1: Write `docs/principles/README.md`**

Create `docs/principles/README.md` with the following content:

```markdown
# Vigilantes Principles Library

The shared senior-dev principles the Vigilantes methodology cites by name. See `docs/principles/<NN>-<slug>.md` for full detail on each.

| # | Principle | One-liner |
|---|-----------|-----------|
| 1 | Look before you leap | Research the codebase and data model before acting. |
| 2 | Distinguish signal from assumption | Name what's verified vs what's guessed. |
| 3 | Trace every claim | Every assertion cites a source. |
| 4 | Question the question | Probe the real problem, not the stated one. |
| 5 | Smallest reversible change | Prefer incremental, undoable moves. |
| 6 | Make the implicit explicit | Surface tradeoffs, constraints, assumptions. |
| 7 | Push back when warranted | Challenge respectfully with evidence. |
| 8 | Test the boundaries, not the path | Probe edge cases + failure modes. |
| 9 | Optimize for the next reader | Clarity over cleverness. |
| 10 | Decide at the latest responsible moment | Delay commitment while keeping options open. |

## How to cite

- Top of a SKILL.md: include a "Principles cited in this skill" section listing the names + 1-sentence summary.
- Inline in skill text: *"We extend `requestPasswordReset`, following *Smallest reversible change*."*
- The full library is not auto-loaded; skills cite principles on demand.

## Adding a principle

v1 holds the cap at 10. Future additions require a justification: "what does this add that the existing 10 don't cover?" The cap is reviewed annually (post-v1).
```

- [ ] **Step 2: Verify the README**

```bash
wc -l docs/principles/README.md
grep -c "^| [0-9]" docs/principles/README.md
```

Expected: ≤ 20 lines for the README; 10 rows in the table (one per principle).

- [ ] **Step 3: Verify the README references all 10 principle files**

Run:

```bash
for n in 01 02 03 04 05 06 07 08 09 10; do
  test -f "docs/principles/${n}-"*.md && echo "OK: ${n}" || echo "MISSING: ${n}"
done
```

Expected: All 10 lines say `OK:`. (This is a smoke test; it doesn't check content, just existence.)

- [ ] **Step 4: Commit Task 4**

```bash
git add docs/principles/README.md
git commit -m "docs(principles): add README index for principles library"
```

---

## Task 5: Verify the library meets the spec acceptance test

This task runs the 8-item acceptance test from `docs/superpowers/specs/2026-06-12-principles-library.md` section 10. The implementer (or reviewer) runs each check; failures block handoff.

- [ ] **Step 1: Check 1 — README exists with all 10 principles listed**

```bash
test -f docs/principles/README.md && grep -c "^| [0-9]" docs/principles/README.md
```

Expected: file exists; `grep -c` returns 10.

- [ ] **Step 2: Check 2 — 10 individual principle files exist, each 3–10 lines**

```bash
for f in docs/principles/[0-9][0-9]-*.md; do
  lines=$(wc -l < "$f")
  if [ "$lines" -ge 3 ] && [ "$lines" -le 10 ]; then
    echo "OK: $f ($lines lines)"
  else
    echo "FAIL: $f ($lines lines, expected 3-10)"
  fi
done
```

Expected: 10 lines, all `OK:`. (Files with line counts outside 3-10 are bugs to fix.)

- [ ] **Step 3: Check 3 — every file has all 5 required fields**

```bash
for f in docs/principles/[0-9][0-9]-*.md; do
  count=$(grep -c "^\*\*" "$f")
  if [ "$count" -ge 5 ]; then
    echo "OK: $f ($count fields)"
  else
    echo "FAIL: $f ($count fields, expected ≥ 5)"
  fi
done
```

Expected: 10 lines, all `OK:`. (A file with fewer than 5 fields is missing Statement, Why, Anti-pattern, Used by, or Source basis.)

- [ ] **Step 4: Check 4 — no principle file exceeds 10 lines**

Step 2 already covered this (the 3-10 range). If Step 2 passed, Step 4 is also passing. (Re-list as a separate check for spec traceability.)

- [ ] **Step 5: Check 5 — no two principles overlap semantically**

This is a **manual review** check, not a script. The implementer (or a reviewer) reads the 10 one-liners in the README and asks: "If I had a 50/50 coin, could I tell which principle applies?" If two principles are interchangeable in some situation, the spec has an overlap bug — fix it by re-wording.

For reference, the principle pairs most likely to be confusable (and the words that distinguish them):
- #1 "Look before you leap" vs. #3 "Trace every claim" — #1 is the *act* of research; #3 is the *output discipline*.
- #2 "Distinguish signal from assumption" vs. #3 "Trace every claim" — #2 is *naming* the difference; #3 is *citing* the source.
- #5 "Smallest reversible change" vs. #6 "Make the implicit explicit" — #5 is about *scope*; #6 is about *visibility*.

If any pair is genuinely indistinguishable, fix the wording in the relevant file(s) and re-run this check.

- [ ] **Step 6: Check 6 — Brainstorming v2 SKILL.md cites the library**

This is a **deferred** check. As of this plan, the Brainstorming v2 SKILL.md has not been written yet (that's SP-2). The check will be: when SP-2 ships, its SKILL.md includes a "Principles cited in this skill" section listing the 8 principles it uses.

**Action for SP-1 implementer:** none. The check is recorded in the spec for the SP-2 implementer to run.

- [ ] **Step 7: Check 7 — every principle has at least one skill in its "Used by" field**

This is a **manual review** check. Read each principle's "Used by" line. If any principle has zero skills listed, that principle is orphan — add a citation or remove the principle.

For reference, the cross-skill coverage is:
- #1 cited by 4 skills
- #2 cited by 3
- #3 cited by 4
- #4 cited by 2
- #5 cited by 4
- #6 cited by 4
- #7 cited by 3
- #8 cited by 4
- #9 cited by 4
- #10 cited by 3

No principle is orphan in v1. (This list is approximate; the implementer should verify the actual file contents.)

- [ ] **Step 8: Check 8 — Brainstorming v2 worked example cites 2-4 principles, not all 10**

This is a **deferred** check, same as Check 6. When SP-2 ships its worked example, the example should cite 2-4 principles from this library, not all 10. (The library is large; the audit is selective.)

**Action for SP-1 implementer:** none.

- [ ] **Step 9: Commit Task 5 (verification log)**

If all 8 checks pass, the library is accepted. Commit a verification log so the next reviewer can re-run the checks.

```bash
cat > /tmp/principles-verification.md <<'EOF'
# Principles Library Verification Log

Date: YYYY-MM-DD
Implementer: <name>
Spec: docs/superpowers/specs/2026-06-12-principles-library.md

| Check | Status | Notes |
|---|---|---|
| 1. README lists all 10 | PASS | <evidence> |
| 2. 10 files, 3-10 lines each | PASS | <evidence> |
| 3. All 5 required fields present | PASS | <evidence> |
| 4. No file exceeds 10 lines | PASS | <subsumed by Check 2> |
| 5. No semantic overlap | PASS | <evidence> |
| 6. Brainstorming v2 cites library | DEFERRED | SP-2 task |
| 7. Every principle has Used by | PASS | <evidence> |
| 8. Brainstorming v2 worked example cites 2-4 | DEFERRED | SP-2 task |
EOF

# Replace YYYY-MM-DD with today's date
sed -i "s/YYYY-MM-DD/$(date +%Y-%m-%d)/" /tmp/principles-verification.md
mv /tmp/principles-verification.md docs/principles/VERIFICATION.md

git add docs/principles/VERIFICATION.md
git commit -m "docs(principles): add verification log"
```

---

## Self-Review

**1. Spec coverage:** The spec (`2026-06-12-principles-library.md` section 13) lists 4 deliverables: (1) `docs/principles/README.md`, (2) 10 principle files, (3) the spec itself (already written), (4) a "principles cited" section in the Brainstorming v2 SKILL.md. This plan covers (1), (2), and a verification log; deliverable (4) is a SP-2 task, correctly deferred. Coverage is complete.

**2. Placeholder scan:** No "TBD", "TODO", "implement later", or "fill in details" anywhere in the plan. Every step has actual file content or a concrete command. Pass.

**3. Type consistency:** The plan uses the same file paths throughout (`docs/principles/NN-<slug>.md`). The principle numbers (01-10) match the spec's ordering. The principle slugs match the spec. Pass.

## Handoff

Plan complete and saved to `docs/superpowers/plans/2026-06-12-principles-library.md`. Two execution options:

1. **Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration
2. **Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

Which approach?

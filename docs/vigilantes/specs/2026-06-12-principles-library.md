# Principles Library

**Status:** Draft v1
**Date:** 2026-06-12
**Author:** Vigilantes planning
**Relates to:** `2026-06-12-vigilantes-methodology-roadmap.md`, `2026-06-12-brainstorming-v2.md`
**Replaces:** nothing (new in v1)
**Depends on:** Rebrand spec (uses `vigilantes` naming)

---

## 1. Overview

The Principles Library is the **shared senior-dev vocabulary** that gives the Vigilantes methodology a single coherent voice. Brainstorming v2, writing-plans v2, and the existing strong skills all cite the same principles by name. When a user reads any one of them, they should feel they are reading the same senior engineer.

It is a **reference**, not a `SKILL.md` — it is not auto-loaded. Each skill that uses the principles includes a short "principles cited" summary at the top of its own SKILL.md, so the agent knows the relevant principles without paying the cost of loading the full library upfront.

The library is small and slow-growing. v1 ships with **10 principles** that cover pre-action discipline, reasoning quality, problem framing, change discipline, communication, critical evaluation, robustness, and decision-making. Additions are deliberate, not opportunistic.

## 2. Goals

- **One voice.** Brainstorming v2, writing-plans v2, code-review, debug — same engineer, same principles.
- **Citation over compliance.** Skills cite principles by name; the audit is visible to the user, not hidden in the agent's reasoning.
- **Right altitude.** Principles are at the level of "Look before you leap", not "Always read the file before editing it". Specific enough to act on, general enough to span many situations.
- **Discoverable.** The agent can find the right principle for a situation by name or by category.
- **Slow-growing.** 10 principles in v1. Each addition has to earn its place. v2 of the methodology can revisit; v1 holds the line.

## 3. Non-Goals

- Do not make this a `SKILL.md` that gets auto-loaded. The library is a reference; skills cite it on demand.
- Do not create a long list. 10 is the v1 cap. Resist additions.
- Do not rewrite TDD's existing "iron law" or verification's "evidence before assertions" as principles. Those are skill-specific. The Principles Library sits one level above them.
- Do not introduce a graph-based indexer. The library is plain markdown.

## 4. The 10 principles (v1)

Each principle is listed with: **Name**, **Statement**, **Why**, **Anti-pattern**, **Used by**, **Source basis**.

### 4.1 Look before you leap

- **Statement:** Research the codebase and data model before acting on a change.
- **Why:** Unverified assumptions are the most expensive kind of bug — they cost an implementation cycle to discover.
- **Anti-pattern:** "Let me ask a few questions to understand the codebase." (Ask second, read first.)
- **Used by:** brainstorming (Phase 1 Data First), writing-plans (evidence grounding), code-review, debug.
- **Source basis:** Common senior-dev practice. Operationalized in this methodology as the "Data First" phase in brainstorming.

### 4.2 Distinguish signal from assumption

- **Statement:** Name what's verified vs what's guessed. Both are allowed; the difference must be visible.
- **Why:** A team that can't tell verified from assumed fact will spend meetings arguing about both in the same voice.
- **Anti-pattern:** "I think the system does X." (No source. Same voice as a verified claim.)
- **Used by:** brainstorming (Phase 1 Data First + Phase 4 question taxonomy), writing-plans (evidence grounding), code-review.
- **Source basis:** Standard epistemic discipline; named in the user's Planning Protocol ("Source Accuracy & Drafting Protocol").

### 4.3 Trace every claim

- **Statement:** Every assertion cites a source — a file:line, a doc section, a prior decision, or an explicit assumption.
- **Why:** Tracing is what lets a future reviewer verify or refute. Untraced claims become folklore.
- **Anti-pattern:** "The system works that way" (no source) vs. "I read `src/auth/handler.ts:42`; the system works that way."
- **Used by:** brainstorming, writing-plans, code-review, debug.
- **Source basis:** User's Planning Protocol explicitly requires this. TDD's "verify RED" mandate is a special case.

### 4.4 Question the question

- **Statement:** Probe the real problem behind the stated one before designing a solution.
- **Why:** Users describe solutions, not problems. Solving the wrong problem with the right technique is still failure.
- **Anti-pattern:** "User asked for X. Build X." (No probe of the underlying problem.)
- **Used by:** brainstorming (Phase 2 Stated vs real problem), writing-plans (consumes the probe's output).
- **Source basis:** Common product-engineering practice. Reframed for coding-agent context.

### 4.5 Smallest reversible change

- **Statement:** Prefer incremental, undoable moves over big-bang rewrites.
- **Why:** Reversible changes lower the cost of being wrong. The cost of an unrevertable mistake is asymmetric.
- **Anti-pattern:** "Let me rewrite the whole module while I'm in there." (Scope creep, irreversibly.)
- **Used by:** brainstorming (Phase 6 approaches), writing-plans (steps ordered by reversibility), code-review, git worktrees.
- **Source basis:** Kent Beck, "Tidy First?", and the broader incremental-design school. Operationalized via the using-git-worktrees skill.

### 4.6 Make the implicit explicit

- **Statement:** Surface tradeoffs, constraints, and assumptions; don't leave them implicit.
- **Why:** Implicit decisions can't be reviewed, can't be changed, and surprise the next person. Explicit decisions are gifts to the team.
- **Anti-pattern:** A design that says "we'll use approach X" without naming the alternatives it beat.
- **Used by:** brainstorming (Phase 6 tradeoff structure, Phase 3 audit), writing-plans, code-review, requesting-code-review.
- **Source basis:** Common engineering-review practice. Reinforced by TDD's anti-patterns and the code-review skills.

### 4.7 Push back when warranted

- **Statement:** Challenge respectfully with evidence when an approach has clear issues. Defer when the other party has more context.
- **Why:** "Yes-man" agents ship bad designs. Contrarian agents slow teams down. The right behavior is calibrated pushback.
- **Anti-pattern:** "Great idea, let's do that!" (no scrutiny) OR "Actually, that won't work because..." (contrarian for sport).
- **Used by:** brainstorming (Phase 5), code-review, receiving-code-review.
- **Source basis:** Standard senior-dev social discipline. Operationalized in brainstorming as a 4-step pattern: name concern → cite evidence → propose alternative → defer to user.

### 4.8 Test the boundaries, not the path

- **Statement:** Probe edge cases, failure modes, and adversarial inputs — not just the happy path.
- **Why:** Happy-path correctness is the cheapest property to achieve. Robustness is the property that matters in production.
- **Anti-pattern:** A test suite that exercises `add(2, 3)` and stops.
- **Used by:** brainstorming (Phase 7 failure-mode pass), TDD (iron law extension), writing-plans, debug.
- **Source basis:** TDD's iron law is the test-time version; the brainstorming extension is design-time. The category list in brainstorming's Phase 7 (10 categories) is the operational checklist.

### 4.9 Optimize for the next reader

- **Statement:** Clarity over cleverness. Code, docs, and messages should be readable by someone who hasn't seen the context.
- **Why:** Code is read more than written. The next reader (often future-you) pays the cost of clever shortcuts.
- **Anti-pattern:** A one-liner that uses five advanced features to replace three readable lines.
- **Used by:** writing-plans (plan clarity), code-review, debugging (variable names, comments), all skill writing.
- **Source basis:** Long-standing software-craft principle. Operationalized in this methodology via the spec self-review checklist and the writing-plans "complete code in every step" rule.

### 4.10 Decide at the latest responsible moment

- **Statement:** Delay commitment while keeping options open. Commit only when the cost of waiting exceeds the cost of locking in.
- **Why:** Early commitments foreclose options you didn't know you'd want. Late commitments keep flexibility — but only if you haven't painted yourself into a corner.
- **Anti-pattern:** Picking a database on day 1 because "we need to pick one", before any feature has constraints.
- **Used by:** brainstorming (Phase 6 approaches), writing-plans (step ordering), subagent-driven-development (parallel work to preserve options).
- **Source basis:** Agile / lean software development canon. Operationalized in this methodology as a tie-breaker for the Phase 6 recommendation.

## 5. File structure

```
docs/
  principles/
    README.md                          # index with one-liner per principle
    01-look-before-you-leap.md
    02-distinguish-signal-from-assumption.md
    03-trace-every-claim.md
    04-question-the-question.md
    05-smallest-reversible-change.md
    06-make-the-implicit-explicit.md
    07-push-back-when-warranted.md
    08-test-the-boundaries-not-the-path.md
    09-optimize-for-the-next-reader.md
    10-decide-at-the-latest-responsible-moment.md
```

10 files, kebab-case slugs, numbered for stable ordering. Each file is short (3–10 lines, including the heading).

## 6. File format

Each principle file uses the following template:

```markdown
# 1. Look before you leap

**Statement:** Research the codebase and data model before acting on a change.

**Why:** Unverified assumptions are the most expensive kind of bug — they cost an implementation cycle to discover.

**Anti-pattern:** "Let me ask a few questions to understand the codebase." (Ask second, read first.)

**Used by:** brainstorming (Phase 1 Data First), writing-plans (evidence grounding), code-review, debug.

**Source basis:** Common senior-dev practice. Operationalized in this methodology as the "Data First" phase in brainstorming.
```

Required fields:
- **Title:** `# <N>. <Name>` — number + name, title case, no period.
- **Statement:** one sentence, present tense, imperative-feeling.
- **Why:** one sentence, names the cost of violation.
- **Anti-pattern:** one concrete example phrased as something the agent might say.
- **Used by:** comma-separated list of skills + the section/phase where it applies.

Optional fields:
- **Source basis:** if the principle is named in a known book, paper, or the user's planning protocol, name it. This satisfies the user's "Source Accuracy" requirement.

Length budget: **3–10 lines per file.** Files longer than 10 lines signal a principle that should be split or a candidate for rejection.

## 7. Index (`docs/principles/README.md`)

A short table the agent (or any reviewer) can scan to find the right principle:

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
```

The README is the **canonical short-form** for the library. It is short enough to be loaded whole if a skill wants to do a principles audit.

## 8. How skills cite principles

A skill that uses the library does **two things**:

1. **Top-of-skill summary.** A short "Principles cited in this skill" section in the SKILL.md, listing the names and a one-sentence summary of each. This is what the agent sees when the skill is loaded.

   ```markdown
   ## Principles cited in this skill

   - **Look before you leap** — Read the codebase before asking clarifying questions.
   - **Distinguish signal from assumption** — Name what's verified vs what's guessed.
   - **Question the question** — Probe the real problem, not the stated one.
   - **Make the implicit explicit** — Surface tradeoffs, constraints, assumptions.
   - **Push back when warranted** — Challenge respectfully with evidence.
   - **Test the boundaries, not the path** — Probe edge cases + failure modes.
   - **Smallest reversible change** — Prefer incremental, undoable moves.
   - **Decide at the latest responsible moment** — Delay commitment while keeping options open.
   ```

2. **Inline citation by name.** When the skill's body makes a decision, it cites the principle that motivates it.

   > "We extend `requestPasswordReset` rather than build a new endpoint, following *Smallest reversible change*."

Inline citation is the **operational form** of the principle. It tells the user *why* the skill is doing what it's doing.

**A skill does NOT:**
- Auto-load the full Principles Library on invocation (cost of context outweighs the benefit).
- Number the principles in user-facing text (the user knows the names, not the numbers).
- Cite all 10 principles for every change (audit is lightweight — 2–4 cited per change).

## 9. Worked example: how Brainstorming v2 uses the library

A user prompt: "Add a 'reset password' button to the login page."

Brainstorming v2's audit:
> **Principles in play:** #1 Look before you leap, #4 Question the question, #5 Smallest reversible change, #6 Make the implicit explicit, #8 Test the boundaries.

Five principles cited — not all 10. The five are the ones that genuinely apply to a small UI feature. #2 (Distinguish signal from assumption) and #3 (Trace every claim) are operationalized implicitly in the Data First phase and don't need to be re-cited at the audit. #7 (Push back) and #9 (Optimize for the next reader) aren't relevant here. #10 (Decide at the latest responsible moment) is a tie-breaker, not a primary lens.

Inline citations in the design:
- "We reuse the existing `requestPasswordReset` API — *Smallest reversible change*."
- "We probe edge cases (empty input, enumeration, rate limiting) — *Test the boundaries*."
- "The design presents 2–3 approaches with explicit pros/cons — *Make the implicit explicit*."

The user sees the principles operating, not just declared.

## 10. Acceptance test

The library is ready when:

- [ ] `docs/principles/README.md` exists with all 10 principles listed and a one-line statement for each.
- [ ] 10 individual principle files exist, each 3–10 lines, using the template in section 6.
- [ ] Every file has all 5 required fields (Title, Statement, Why, Anti-pattern, Used by).
- [ ] No principle file exceeds 10 lines.
- [ ] No two principles overlap semantically (test: a reviewer reading the one-liners can't tell which one applies).
- [ ] At least 3 skills cite the library by name in their SKILL.md (Brainstorming v2, writing-plans v2, code-review).
- [ ] The "Used by" field in each principle file lists at least one skill — none of the 10 is orphan.
- [ ] Brainstorming v2's worked example (per the Brainstorming v2 spec) cites 2–4 principles, not all 10.

## 11. Risks + mitigations

| Risk | Mitigation |
|---|---|
| Library grows to 25+ principles over time. | Hard cap in this spec: 10 in v1. Future additions require a PR + an explicit "what does this add that the existing 10 don't cover?" justification. |
| Principle names are too abstract to act on. | Each principle's "Anti-pattern" is a concrete sentence the agent might say. Forces the abstract to be specific. |
| "Used by" lists become stale as skills evolve. | v2 of the methodology (post-v1) includes a sweep that updates "Used by" when skills change. Out of scope for v1. |
| Principles overlap with skill-specific content (TDD's "iron law", verification's "evidence before assertions"). | Principles sit one level above skill-specific patterns. The skill-specific content is the operational form; the principle is the abstraction. (Example: TDD's iron law *is* principle #8 in test form.) |
| Citations become performative (agent cites all 10 every time). | Section 8 of this spec + the Brainstorming v2 spec's "voice" section both call this out explicitly. The worked example shows selective citation. |
| The "Source basis" field becomes a research task that blocks shipping. | v1 principles have a "Source basis" line that names the practice they distill (e.g., "Common senior-dev practice", "Kent Beck, Tidy First?"). No external research required. |

## 12. Open questions

1. **Should the README include a "Categories" column** (pre-action, reasoning, problem framing, etc.)?
   *Proposed:* No. Categories are useful for organizing the library, but a category column makes the index more complex without adding information the agent uses. If categorization becomes useful, add a `docs/principles/CATEGORIES.md` as a side reference.

2. **Should there be a `using-vigilantes`-level "principles pointer"** that mentions the library exists?
   *Proposed:* No. The library is a reference, not a runtime concept. The bootstrap doesn't need to mention it. Skills that cite it mention it.

3. **Should principle numbers be permanent** (so #5 is always "smallest reversible change")?
   *Proposed:* Yes, for v1. Numbers are part of the index. Re-numbering is a v2 task. v1 holds the order.

4. **Should a principle's file include a "Worked example"**?
   *Proposed:* No — the file is short by design (3–10 lines). Examples live in the skills that cite the principle (e.g., the Brainstorming v2 worked example shows principles in action). Adding examples to principle files duplicates and bloats.

5. **What if a future skill needs a principle that isn't in the library?**
   *Proposed:* That skill's spec proposes the new principle with the "what does this add that the existing 10 don't cover?" justification. The 10-cap is reviewed annually (post-v1). v1 doesn't add new principles opportunistically.

6. **Should the principles themselves be versioned** (v1 library, v2 library, etc.)?
   *Proposed:* Not formally in v1. The library is content; the methodology's version (5.1.0 → 6.0.0 etc.) tracks it implicitly. If a principle changes meaning in a breaking way, it's a methodology major version bump.

## 13. Deliverables

When SP-1 starts, the deliverable is:

- `docs/principles/README.md` — index, ~20 lines
- 10 principle files at `docs/principles/NN-<slug>.md` — each 3–10 lines
- This spec (Principles Library spec, already written)
- A short "principles cited" section in the Brainstorming v2 SKILL.md (shipped together with the library, even though Brainstorming v2 is SP-2 — see open question 4 in the Brainstorming v2 spec)

**Total: ~120 lines of content across 11 files.** Small, intentional, slow-growing.

## 14. References

- **Roadmap spec:** `docs/superpowers/specs/2026-06-12-vigilantes-methodology-roadmap.md` (initial principle candidates)
- **Brainstorming v2 spec:** `docs/superpowers/specs/2026-06-12-brainstorming-v2.md` (primary consumer)
- **Rebrand spec:** `docs/superpowers/specs/2026-06-12-vigilantes-rebrand.md` (uses `vigilantes` naming)
- **writing-plans v2 spec:** forthcoming (SP-3, secondary consumer)
- **TDD v1** (existing skill that operationalizes principle #8 in test form): `skills/test-driven-development/SKILL.md` (371 lines)
- **verification-before-completion** (existing skill that operationalizes principle #3): `skills/verification-before-completion/SKILL.md`
- **code-review skills** (existing consumers of principles #1, #3, #6, #7, #9): `skills/requesting-code-review/SKILL.md`, `skills/receiving-code-review/SKILL.md`

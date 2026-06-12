# Vigilantes Methodology Roadmap

**Status:** Draft v1
**Date:** 2026-06-12
**Author:** Vigilantes planning
**Relates to:** `2026-06-12-vigilantes-rebrand.md` (rebrand done first)

---

## 1. Overview

This roadmap upgrades the superpowers methodology into the **Vigilantes** methodology — a coding-agent discipline that reads as senior-dev tier, not junior-dev.

Three v1 sub-projects, in this order:

1. **Principles Library** — the shared senior-dev principles all skills will cite.
2. **Brainstorming v2** — the biggest lift; replaces the current weakest skill.
3. **writing-plans v2** — refinement; uses the principles and Brainstorming v2's outputs.

Graphify (graph-based codebase indexing) is **explicitly out of scope** for v1, per user.

Each sub-project gets its own detailed spec when its work starts. This roadmap is meta — it defines what each sub-project is, why it exists, and how they fit together. It does not specify their internals.

---

## 2. Goals

- **One coherent voice.** The methodology reads as a single senior engineer, not 14 different ones. Shared principles + consistent structure.
- **Senior-dev tier on the soft skills.** Brainstorming is the entry point for every user; it sets the tone for everything downstream. v2 makes it the canonical demo of the senior pattern.
- **Evidence-grounded reasoning.** Plans and reviews cite the same principles and trace claims to sources — no invention, no "sounds right" reasoning.
- **Composable skills.** Skills reference the Principles Library by name; downstream skills consume Brainstorming v2's outputs as inputs.

## 3. Non-Goals

- Do not rewrite every skill. Only the 3 with the biggest gaps. Strong skills (TDD, code-review, verification) stay as-is for v1.
- Do not change the skill structure (frontmatter, `SKILL.md` layout, by-name loading). All skill changes are content-only.
- Do not break the existing TDD / verification / code-review disciplines. They are the foundation.
- Do not introduce graphify, vector search, or any codebase-indexing subsystem in v1.

---

## 4. Sub-Project Definitions

### SP-1 — Principles Library

**Why it goes first:** Brainstorming v2 and writing-plans v2 both *cite* the Principles Library. It must exist before skills can reference it.

**Goal:** Define the senior-dev principles the methodology embodies, in a single referenceable place.

**Where it lives (proposed):** `docs/principles/` (markdown files, one per principle). Not a `skills/` entry — it is a *reference*, not an auto-loaded skill. Each principle is short (3-10 lines) and skimmable.

**Initial principle candidates** (final list and exact wording are set in the Principles Library spec when SP-1 starts):

| # | Name | One-liner |
|---|------|-----------|
| 1 | Look before you leap | Research the codebase and data model before acting |
| 2 | Distinguish signal from assumption | Name what's verified vs what's guessed |
| 3 | Trace every claim | Every assertion cites a source |
| 4 | Question the question | Probe the real problem, not just the stated one |
| 5 | Smallest reversible change | Prefer incremental, undoable moves |
| 6 | Make the implicit explicit | Surface tradeoffs, constraints, assumptions |
| 7 | Push back when warranted | Challenge respectfully with evidence |
| 8 | Test the boundaries, not the path | Probe edge cases + failure modes |
| 9 | Optimize for the next reader | Clarity over cleverness |
| 10 | Decide at the latest responsible moment | Delay commitment while keeping options open |

**Cited by:** Brainstorming v2, writing-plans v2, code-review (existing), debug (existing), requesting-code-review (existing), verification-before-completion (existing).

**Deliverable:**
- `docs/principles/README.md` — index of all principles
- `docs/principles/<NN>-<slug>.md` — one short file per principle (3-10 lines each)
- A canonical short-form (single line per principle) suitable for inline citation

### SP-2 — Brainstorming v2

**Why it goes second:** Biggest lift. v1 is the weakest skill (164 lines, no data-first, no question taxonomy, no pushback, no principles audit). v2 is the canonical demo of the senior pattern.

**Goal:** Replace the current brainstorming skill with one that demonstrates senior-dev discipline end-to-end.

**Key v2 changes (high-level, full detail in the Brainstorming v2 spec when it starts):**

- **Data First phase** before the first clarifying question — read relevant code, read the data model, cite what was found.
- **Question taxonomy** — distinguish fact-finding, decision, tradeoff, constraint, and clarification questions; ask in the right order.
- **Real problem vs stated problem** probe — verify the user's stated goal is the actual goal.
- **Principles audit** — name which Principles Library entries apply to the change.
- **Pushback pattern** — challenge respectfully with evidence when the proposed approach has clear issues.
- **Tradeoff structure** — present options with explicit pros/cons + a recommendation, not just a list.
- **Failure-mode pass** — explicitly probe edge cases, security, performance, scale before declaring "ready to plan".

**Deliverable:**
- `skills/brainstorming/SKILL.md` v2 (replaces v1)
- Updated `skills/brainstorming/visual-companion.md` (if needed for the new structure)
- A small set of worked examples showing the senior pattern end-to-end
- A dedicated **Brainstorming v2 spec** at `docs/superpowers/specs/2026-06-12-brainstorming-v2.md` (written when SP-2 starts)

### SP-3 — writing-plans v2

**Why it goes third:** Already competent (152 lines). v2 is a refinement, not a rewrite. It depends on the Principles Library existing and on Brainstorming v2 producing the inputs the plan should consume.

**Goal:** Make plans evidence-grounded, tradeoff-aware, and traceable.

**Key v2 changes (high-level, full detail in the writing-plans v2 spec when it starts):**

- **Principles citation** — every plan step cites which Principles Library entries apply.
- **Evidence grounding** — every claim in the plan is traceable to a source (the brainstorm's Data First brief, prior research, or an explicit assumption).
- **Consume Brainstorming v2 outputs** — the plan's structure is downstream of the brainstorm's real-problem + tradeoff + failure-mode analysis.
- **Tradeoff section** — plans explicitly document the tradeoffs they commit to.
- **Failure-mode pass** — every step is checked for what could go wrong, with a "what if this fails" note.
- **Self-review at the spec level** — before publishing the plan, the agent runs the plan through a checklist (no placeholders, bite-sized, complete code, exact paths).

**Deliverable:**
- `skills/writing-plans/SKILL.md` v2 (replaces v1)
- A small set of worked examples showing a plan that consumes a Brainstorming v2 output
- A dedicated **writing-plans v2 spec** at `docs/superpowers/specs/YYYY-MM-DD-writing-plans-v2.md` (written when SP-3 starts)

---

## 5. Order of Execution + Dependencies

```
SP-1 Principles Library ─────┐
                              ├──► SP-2 Brainstorming v2 ──┐
                                                            ├──► SP-3 writing-plans v2
                              (v2 cites principles)        │    (v2 cites principles + consumes v2 outputs)
```

- **SP-1 has no dependencies.** Can start now (after rebrand is shipped).
- **SP-2 depends on SP-1** (its principles audit cites the library) and the rebrand (skills are now under the `vigilantes` plugin). Brainstorming v2 does not need Brainstorming v1's data — it can be a clean replacement.
- **SP-3 depends on SP-1 and SP-2** (it cites the library + consumes Brainstorming v2 outputs).

**Recommended cadence:**
- SP-1 first (~1–2 sessions, mostly writing 10 short files + a README)
- SP-2 next (~2–4 sessions, brainstorming v2 is the biggest piece)
- SP-3 last (~1–2 sessions, refinement)

---

## 6. What we are explicitly NOT touching in v1

These skills are already strong and stay as-is for v1. They may *cite* the Principles Library in future updates, but v1 does not modify them.

| Skill | Why untouched |
|---|---|
| `test-driven-development` | 371 lines. Iron law, anti-patterns, RED verification, no-rationalizations table. Reference standard. |
| `verification-before-completion` | Strong evidence-before-assertions discipline. |
| `requesting-code-review` / `receiving-code-review` | Well-structured. |
| `systematic-debugging` | Solid debugging discipline. |
| `using-superpowers` → `using-vigilantes` (after rebrand) | Auto-injected; minimal content. Rebrand is the only change. |
| `using-git-worktrees`, `subagent-driven-development`, `dispatching-parallel-agents`, `executing-plans`, `finishing-a-development-branch` | Competent; no v1 work planned. |

A v2 round in the future *may* add Principles Library citations to these skills. Out of scope for v1.

---

## 7. Success Criteria

- [ ] All 3 sub-projects shipped as working skills.
- [ ] Principles Library is referenced by **at least 3 other skills** (Brainstorming v2, writing-plans v2, and one of code-review / debug / verification).
- [ ] Brainstorming v2 is **qualitatively more senior** than v1 — verified by a real session test where the user gives a tricky problem and the skill's output reads as senior-dev work.
- [ ] writing-plans v2 plans are **executable end-to-end** by a subagent who has not seen the original problem.
- [ ] The methodology has a **single coherent voice** — a user reading any one of the 3 v2 skills feels they are reading the same engineer.

## 8. Risks + Mitigations

| Risk | Mitigation |
|---|---|
| Brainstorming v2 SKILL.md balloons (v1 is 164 lines, v2 has ~7 new sections). | Keep SKILL.md scannable. Push detail to `visual-companion.md`. Add an "abbreviated mode" for low-risk changes. |
| Principles Library overlaps with existing skill content (TDD already has "iron law", verification has "evidence before assertions"). | Pick principle abstractions that are at the right altitude — not too generic ("be careful") and not too specific ("TDD's iron law"). |
| Forcing principles citation feels bureaucratic (every brainstorm cites 5 principles). | Principles audit is lightweight — usually 2-3 cited, not all 10. Optional for low-risk changes. |
| "Data First" slows down quick brainstorms. | Scale the depth of Data First to the change's risk profile. A typo fix doesn't need a 5-file research summary. |
| Brainstorming v2 + writing-plans v2 drift apart in voice. | Both cite the Principles Library. Spec for each sub-project includes a "voice checklist" referencing the same source. |

## 9. Open Questions

1. **Principles Library: `docs/principles/` (reference) vs `skills/principles/SKILL.md` (auto-loaded skill)?**
   *Proposed:* `docs/principles/` — reference, not auto-loaded. Avoids context bloat. Individual skills load principles by name when they need them.
   *Tradeoff:* A `SKILL.md` version would guarantee the agent sees all principles on every session start. But that's a lot of context for a low-frequency use. Recommend `docs/principles/`.

2. **Should the Principles Library be its own skill loaded by name (e.g. `using-vigilantes` injects it)?**
   *Proposed:* No. The principles are a *reference* the other skills cite. They are not an action the agent takes. If the user invokes `/principles`, that can be a thin wrapper that displays the index — but it is not in the bootstrap.

3. **How do we measure "senior" qualitatively?**
   *Proposed:* User feedback + side-by-side comparison vs v1 on a tricky real prompt. No objective metric; senior-ness is recognized, not measured. Bake this into the Brainstorming v2 spec's acceptance test.

4. **Should the rebrand be merged before SP-1 starts, or in parallel?**
   *Proposed:* Rebrand first. It changes the `using-superpowers` skill name (`using-vigilantes`) and the plugin manifest names. Doing it first means SP-1 doesn't write principles under the old name and rebrand them later.

## 10. References

- **Rebrand spec:** `docs/superpowers/specs/2026-06-12-vigilantes-rebrand.md` (done)
- **Brainstorming v1** (current, weakest): `skills/brainstorming/SKILL.md` (164 lines)
- **writing-plans v1** (current, competent): `skills/writing-plans/SKILL.md` (152 lines)
- **TDD v1** (current, reference standard): `skills/test-driven-development/SKILL.md` (371 lines)
- **using-vigilantes v1** (post-rebrand equivalent of using-superpowers): `skills/using-vigilantes/SKILL.md` (117 lines)
- **Brainstorming v2 spec:** forthcoming (written when SP-2 starts)
- **writing-plans v2 spec:** forthcoming (written when SP-3 starts)
- **Principles Library spec:** forthcoming (written when SP-1 starts)

<!--
⚠️ DO NOT DELETE THIS FILE

This is a reference template used by the `brainstorming` skill to scaffold
new design spec files. When `brainstorming` reaches Phase 9 (Spec write +
self-review), the agent copies this file to a new spec path
(typically `docs/vigilantes/specs/YYYY-MM-DD-<topic>-design.md`) and
fills in the sections.

The template is the contract. Do not change the section headings; the
agent (and reviewers) rely on them. If you need to change the structure
of generated specs, edit this template AND update the corresponding
phase in `skills/brainstorming/SKILL.md` to match.
-->

# Design: <Topic>

**Date:** YYYY-MM-DD
**Author:** <agent or user>
**Status:** Draft | Approved | Superseded

## Problem restatement

The real problem (not the stated one) — 1-3 sentences. State the underlying
need the user is trying to address, not the surface-level feature request.

> Example: "Users who forget passwords email support; each ticket costs ~30
> minutes of agent time. We want to deflect that."

## Principles in play

Cite 2-4 principles from the brainstorming skill's library (full definitions
are inlined in the skill itself; cite by name here). For each, name the
one-sentence application to this specific design.

- **<Principle name>** — <how it shapes this design>
- **<Principle name>** — <how it shapes this design>

## Approach

The chosen approach, named in 1-2 sentences. State the recommendation
up front; explain after.

### Rejected alternatives

**Approach B — <name>:**
- *Why considered:* <what it promised>
- *Why rejected:* <concrete reason; cite a constraint, evidence, or principle>

**Approach C — <name>:**
- *Why considered:* <what it promised>
- *Why rejected:* <concrete reason>

## Failure modes addressed

List the categories probed (from the brainstorming skill's 10-category pass).
≥3 concrete probes for medium-risk; all 10 for high-risk. For each, name the
failure mode and the mitigation.

| Category | Failure mode | Mitigation |
|----------|--------------|------------|
| Empty input | <what can be empty/null/whitespace> | <how we handle it> |
| Boundaries | <edge of valid range> | <how we handle it> |
| Concurrency | <simultaneous-event risk> | <how we handle it> |
| Auth | <auth-related risk> | <how we handle it> |
| Injection | <injection vector> | <how we handle it> |
| Sensitive data | <leakage vector> | <how we handle it> |
| Performance | <load-related risk> | <how we handle it> |
| Backwards compat | <existing-behavior risk> | <how we handle it> |
| Reversibility | <rollback risk> | <how we handle it> |
| Observability | <blind-spot risk> | <how we handle it> |

## Open questions

Anything still undecided. Low priority — can be deferred to writing-plans.
Each item should be a question that the implementer can answer without
re-doing the design.

- <Question 1>
- <Question 2>

## Out of scope

What this design explicitly does NOT do. Naming these protects the next
phase from scope creep.

- <Out of scope item 1>
- <Out of scope item 2>

## Verification (handed off to writing-plans)

The implementer verifies the design by running the verifications defined
in the implementation plan. No code, file paths, or dependency versions
belong in this spec — those go in writing-plans.

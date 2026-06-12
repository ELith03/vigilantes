# Brainstorming v2 — Senior-Dev Tier

**Status:** Draft v1
**Date:** 2026-06-12
**Author:** Vigilantes planning
**Relates to:** `2026-06-12-vigilantes-rebrand.md`, `2026-06-12-vigilantes-methodology-roadmap.md`
**Replaces:** `skills/brainstorming/SKILL.md` v1 (164 lines, current)
**Depends on:** `docs/principles/` (Principles Library, SP-1) — must exist before v2 SKILL.md cites it

---

## 1. Overview

Brainstorming is the entry point for every Vigilantes change. It sets the tone for everything downstream. v1 is functional but reads junior — it runs through a checklist (9 items, linear) without:

- Requiring evidence before questions.
- Distinguishing question types.
- Pushing back when warranted.
- Citing shared senior-dev principles.
- Probing failure modes before declaring "ready to plan".

v2 is the **canonical demo of the senior pattern.** A user who runs a tricky real prompt through it should get output that reads as a senior engineer thinking out loud — not a checklist being walked.

v2 does not change the SKILL.md structure (still frontmatter + markdown, still loaded by name `brainstorming`). It is a content replacement.

## 2. Goals

- **Evidence-first.** The agent reads the codebase, reads the data model, and *cites* what it found before asking the first clarifying question. No "I assume" without source.
- **Principled.** Every brainstorm names which senior-dev principles apply. Citation, not just compliance.
- **Challenging.** When the user's approach has clear issues, the agent pushes back respectfully with evidence. "Yes-man" is not senior.
- **Tradeoff-aware.** Options are presented as structured tradeoffs (pros/cons/cost/risk/recommendation), not flat lists.
- **Failure-aware.** Before "ready to plan", the agent runs a failure-mode pass: edge cases, security, performance, scale, reversibility.
- **Right-sized.** A typo fix does not need 5 files of research. A platform rewrite does. The depth of v2 scales to the change's risk profile.
- **Single voice.** Brainstorming v2 + writing-plans v2 + code-review all read as the same senior engineer, because they all cite the same Principles Library.

## 3. Non-Goals

- Do not introduce a graph-based codebase indexer (graphify is explicitly excluded from v1).
- Do not add a new skill. v2 *is* the brainstorming skill; it replaces v1's content.
- Do not change the bootstrap (still loaded by name; the `using-vigilantes` skill does not auto-invoke it).
- Do not change the visual companion mechanism (preserve as-is; it's already opt-in and well-scoped).
- Do not replace the hard-gate against implementation. Keep it. Strengthen it if anything.

## 4. The v2 Process (phased)

v2 is not a linear checklist. It is **phased**, with the depth of each phase scaled to the change's risk profile.

| # | Phase | Purpose | Always? |
|---|-------|---------|---------|
| 0 | **Scope-risk profile** | Quick read on the change's size + risk; sets the depth of later phases. | Always (cheap) |
| 1 | **Data First** | Read codebase, data model, adjacent features. Cite what was found. | Always |
| 2 | **Stated vs real problem** | Verify the user's stated goal is the actual goal. Push back if not. | Always |
| 3 | **Principles audit** | Name which senior-dev principles apply to this change. | Always (light) |
| 4 | **Question taxonomy** | Classify each question. Order: fact → constraint → decision → tradeoff → clarification. | Always |
| 5 | **Pushback when warranted** | Challenge respectfully with evidence if approach has clear issues. | When triggered |
| 6 | **2–3 approaches with tradeoff structure** | Pros / cons / cost / risk / recommendation. | Always |
| 7 | **Failure-mode pass** | Edge cases, security, performance, scale, reversibility. | Always (scaled) |
| 8 | **Design presentation** | Architecture, components, data flow, error handling, testing. Section-by-section approval. | Always |
| 9 | **Spec write + self-review** | Save to `docs/superpowers/specs/`. Self-review: placeholders, consistency, scope, ambiguity. | Always |
| 10 | **User review gate** | User reads spec before implementation. | Always |
| 11 | **Transition to writing-plans** | Invoke writing-plans (only). | Always |

Phases 0–3 happen *before* the first clarifying question. The hard-gate is preserved and strengthened: no implementation action until the design is approved.

## 5. Phase-by-phase detailed behavior

This is the meat — the sections that go into the v2 SKILL.md (with examples). Each phase describes the agent's expected behavior.

### Phase 0 — Scope-risk profile

**What:** A 30-second internal classification. The agent reads the request and decides: is this a `low` / `medium` / `high` risk change?

- **Low:** typo fix, config change, one-file refactor with clear scope.
- **Medium:** new feature touching 1–3 components, well-understood domain.
- **High:** new subsystem, cross-cutting change, security-sensitive, performance-critical, or unknown domain.

**Why:** The depth of later phases scales to this. Low risk does not need a 5-file research summary. High risk does.

**Output (internal, not necessarily shown to user):** A one-line classification the agent uses to decide how deep to go in Phases 1, 4, 7.

**Scale rule:**
- Low → Data First = 1–2 files max; question count = 1–3; failure-mode pass = quick.
- Medium → Data First = 3–5 files; question count = 3–5; failure-mode pass = structured.
- High → Data First = 5+ files + data model; question count = 5+ (often broken into sub-brainstorms); failure-mode pass = thorough.

### Phase 1 — Data First

**What:** Before the first clarifying question, the agent reads the relevant code.

**The rule:** *Every claim made in the brainstorm must trace to a source the agent has actually read.* "I think the system does X" → not allowed without a file:line citation. "I read `src/auth/handler.ts:42` and the system does X" → allowed.

**Minimum actions:**
- Read files most directly relevant to the change.
- Read the data model if the change touches data.
- Read 1–2 adjacent features to understand the pattern.

**Output to user (concise):** A short summary: "Read N files. Current state: [one paragraph]. Adjacent patterns: [one line]." Cite file paths and line numbers inline.

**Tie-in to principles:** This is the operational form of *Look before you leap* and *Trace every claim*.

**Anti-pattern (avoid):** "Let me ask a few questions to understand the codebase." No. Read first. Ask second.

### Phase 2 — Stated vs real problem probe

**What:** Verify the user's stated goal is the actual goal.

**Why:** Users often describe the solution they want, not the problem they're solving. "Add a button that does X" is a solution. "I'm tired of doing X manually" is the problem. The agent checks the two match.

**How:**
- Restate the stated problem in the agent's own words.
- Ask: "Is the underlying problem X, or am I missing something?" (single question, optional based on confidence)
- If the agent suspects the real problem is different, name the suspicion and ask.

**Tie-in to principles:** *Question the question.*

**When to skip:** Low-risk changes where the stated problem is obviously the right one. Use judgment.

### Phase 3 — Principles audit

**What:** Name which Principles Library entries apply to this change. Cite by number/name.

**Output to user (lightweight):** A short line: "Principles in play: #1 Look before you leap, #6 Make the implicit explicit, #8 Test the boundaries." Not a 10-item list. Usually 2–4 principles.

**Tie-in to principles:** *Make the implicit explicit.* The principles audit makes the methodology's voice visible.

**Anti-pattern (avoid):** Citing all 10 principles for every change. That is bureaucratic, not principled. Cite the ones that genuinely apply.

### Phase 4 — Question taxonomy

**Five types of clarifying question.** The agent classifies each question before asking, and orders them.

| Type | Purpose | Example | When in order |
|------|---------|---------|---------------|
| **Fact-finding** | Resolve a factual gap; often answerable by reading the code. | "Does the system already have a notion of sessions?" | Early — Data First should resolve many of these. |
| **Constraint** | Hard requirement the user has. | "Must this work in IE11?" | Early — sets the design space. |
| **Decision** | Choice the user makes. | "Should X be sync or async?" | Middle — after facts and constraints are known. |
| **Tradeoff** | Weighing options; answer involves values. | "Do you prefer speed of implementation or flexibility?" | Middle — same as decisions, often paired. |
| **Clarification** | Disambiguate something the user said. | "When you say 'fast', sub-100ms or sub-1s?" | Anytime — often resolved by re-reading what the user wrote. |

**Rules:**
- **One question per message.** (Preserved from v1.)
- **Multiple choice preferred** for decisions and tradeoffs. (Preserved from v1.)
- **Fact-finding questions should be rare** if Data First was done well — the agent should have read the answer already.
- **Order:** facts → constraints → decisions/tradeoffs → clarifications (last).
- **State the type** implicitly (e.g., "Constraint check: must this work offline?") so the user understands what kind of question it is.

**Tie-in to principles:** *Make the implicit explicit.* Naming the type makes the question's purpose visible.

### Phase 5 — Pushback when warranted

**When to push back:**
- The proposed approach has clear technical issues (cite the issue with evidence).
- The scope is bigger than the user thinks (cite what's hidden).
- The approach duplicates existing functionality (cite the existing code).
- The user is over-engineering (cite YAGNI / *Smallest reversible change*).
- The user is under-engineering (cite the failure modes that will hit).
- The constraints stated are impossible or contradictory (cite the contradiction).

**How to push back (the format):**
1. Name the concern concretely. "I'm seeing a potential issue with X."
2. Cite the evidence. "In `src/auth/handler.ts:42`, the system already does Y, so adding Z duplicates it."
3. Propose an alternative. "What if we extend Y instead?"
4. Defer to the user. "But you may have context I don't. Worth thinking about."

**Tone:** Respectful, evidence-grounded, not contrarian for sport. Pushback is a tool, not a posture.

**When NOT to push back:**
- The user has more context than the agent (acknowledge this and defer).
- The choice is purely preferential (no "right" answer).
- The risk is low and the agent is being pedantic.

**Tie-in to principles:** *Push back when warranted.* Not *always push back*.

**Anti-pattern (avoid):** Sycophantic "great idea!" followed by implementation. Also avoid contrarian "actually..." on every message.

### Phase 6 — 2–3 approaches with tradeoff structure

**Format (per option):**
- **Name.** Short label.
- **Summary.** What it is, in one sentence.
- **Pros.** What it gains.
- **Cons.** What it costs.
- **Cost.** Effort to implement (rough — small / medium / large).
- **Risk.** What could go wrong.
- **Recommendation.** Yes / no, and why.

**Order:** Lead with the recommended option, not alphabetical. Explain why.

**Count:** 2–3. Not 5. Not 1. If there's only one sensible approach, say so explicitly and explain why alternatives are worse.

**Tie-in to principles:** *Make the implicit explicit* (tradeoffs visible) and *Decide at the latest responsible moment* (don't commit before the user chooses).

### Phase 7 — Failure-mode pass

**What:** Before declaring "ready to plan", the agent probes what could go wrong. This is not a separate question phase — it's a section in the design.

**Categories (default checklist, scaled to risk profile):**

| Category | Probe |
|---|---|
| Empty input / no data | What happens with zero / null / missing? |
| Boundary values | Off-by-one, max, min, very large, very small? |
| Concurrency | Race conditions, deadlocks, ordering? |
| Auth / authorization | Who can do this? How is that enforced? |
| Injection / XSS / SQLi | Untrusted input paths? |
| Sensitive data exposure | Logging? Errors leaking PII? |
| Performance under load | N+1, hot paths, memory leaks? |
| Backwards compatibility | Will this break existing consumers? Migration story? |
| Reversibility | Can we undo this? What's the rollback? |
| Observability | Can we tell if it's working? Metrics, logs, alerts? |

**How to present:** As a table or a short list per category. For each: "Probe: [what we tested]. Result: [OK / risk / unknown]." If unknown, that's a follow-up question, not a blocker.

**Tie-in to principles:** *Test the boundaries, not the path* and *Smallest reversible change*.

### Phase 8 — Design presentation

**Preserved from v1**, with two refinements:

1. **Cite principles inline.** When presenting a design decision, name the principle that motivates it. "We're using feature flags here because of *Smallest reversible change*."

2. **Add a 'why this approach' recap** at the start of the design. One paragraph that summarizes the tradeoff decision from Phase 6. The user already approved the approach — the recap is the design's headline.

**Sections (preserved from v1, scaled to complexity):**
- Architecture
- Components
- Data flow
- Error handling
- Testing

**Section-by-section approval:** still required. The agent asks after each section whether it looks right.

### Phase 9 — Spec write + self-review

**Preserved from v1**, with one addition: **the spec must include a 'Principles cited' line near the top** so reviewers see the audit at a glance.

Self-review checklist (preserved from v1, refined):
1. **Placeholder scan:** TBD, TODO, vague requirements. Fix.
2. **Internal consistency:** architecture matches features, components match data flow. Fix.
3. **Scope check:** focused enough for one plan, or needs decomposition? If too big, flag and propose split.
4. **Ambiguity check:** could anything be read two ways? Pick one and make it explicit.
5. **NEW: Principles cited?** If the spec cites principles, are they the right ones? Cross-check against the Phase 3 audit.
6. **NEW: Failure modes addressed?** Did the Phase 7 pass get captured in the spec? If not, capture it.

### Phase 10 — User review gate

**Preserved from v1.** Unchanged.

### Phase 11 — Transition to writing-plans

**Preserved from v1.** The terminal state is invoking writing-plans. Nothing else.

## 6. Voice + style

The v2 SKILL.md itself must read senior, not bureaucratic. Rules for the writing:

- **Tone:** senior engineer thinking out loud, not a checklist being walked.
- **Phrasing:** active, direct, evidence-grounded. No "you might want to consider..." — yes, you should consider, here's why.
- **Examples:** concrete, with file:line citations. "Read `src/auth/handler.ts:42`..." — not "in the auth handler..."
- **Anti-patterns:** call out the junior behaviors by name, with a one-line "what it looks like" and "what to do instead".
- **Length budget:** v2 SKILL.md target ~280–350 lines (up from v1's 164). Growth is justified by the new phases, not by padding.
- **Detail in visual-companion.md, not in SKILL.md.** Push verbose examples and edge cases to the companion file. Keep the main skill scannable.

## 7. Worked example (one, illustrative)

**User prompt:** "Add a 'reset password' button to the login page."

**Phase 0:** Low-to-medium risk. Touches one feature, but auth-adjacent.

**Phase 1 (Data First):** Read `src/auth/login.tsx`, `src/auth/handler.ts`, `src/db/users.ts`. Found: existing `requestPasswordReset(email)` API in handler.ts:42. Email service in `src/email/`. No UI for it. Summary: "Backend exists, no UI. Email service is template-based, no token expiry on existing flow."

**Phase 2 (Stated vs real):** Stated: "add a reset button." Real: probably "users get locked out and there's no recovery." Same problem, different framing. No need to push back.

**Phase 3 (Principles audit):** #1 Look before you leap (done), #5 Smallest reversible change (low-risk UI add), #6 Make the implicit explicit (token expiry question).

**Phase 4 (Questions, in order):**
- Fact: skip — Data First answered the structural questions.
- Constraint: "Must this support a captcha or rate limit?" (1 question)
- Decision: "Inline modal or new page?" (1 question)
- Clarification: "When the user clicks the link in the email, do they land on a 'set new password' form, or on a 'login' page?" (1 question)

**Phase 5 (Pushback):** None warranted. Existing API is sensible.

**Phase 6 (Approaches):**
- **A (recommended):** Add a small "forgot password?" link below the password field that opens a modal asking for email; reuse existing API.
  - Pros: small surface, reuses tested API, no migration.
  - Cons: requires modal component (small).
  - Cost: small.
  - Risk: low; we tested the API.
- **B:** New `/reset` page with a multi-step form.
  - Pros: more room for explanation, accessibility win.
  - Cons: more code, more state to manage, slower to ship.
  - Cost: medium.
  - Risk: low.
- **C:** Use a third-party password-reset service.
  - Pros: handles edge cases (rate limiting, captcha) for us.
  - Cons: new vendor, new secret to manage, new cost center.
  - Cost: small to integrate, ongoing cost.
  - Risk: medium (vendor lock-in).

Recommendation: A. The change is small, the existing API is already there, and B/C add complexity the user didn't ask for.

**Phase 7 (Failure modes):**
- Empty input: form validation, OK.
- Boundary values: email regex covers it.
- Concurrency: N/A, single user.
- Auth: "request reset" doesn't require auth; "complete reset" needs the token. OK.
- Injection: email field is sanitized; token in URL is signed.
- Sensitive data: response must not leak whether email exists (enumeration attack). Existing API already returns 200 for both cases — good.
- Performance: N/A, low traffic.
- Backwards compat: existing API unchanged. New UI is additive.
- Reversibility: full — remove the link, remove the modal. No migration.
- Observability: log reset requests (rate-limit signal).

All probes OK. Ready to plan.

**Phase 8 (Design):** Architecture = frontend-only addition. Component = `<ForgotPasswordModal>`. Data flow = POST `/auth/request-reset` with email. Error handling = same response for "email not found" and "sent" to prevent enumeration. Testing = unit (modal flow, validation) + integration (request hits API with right payload).

**Phase 9 (Spec):** Save to `docs/superpowers/specs/YYYY-MM-DD-reset-password-ui.md`. Self-review: no placeholders, scope is one feature, ambiguities (token expiry? default rate limit?) resolved during Q&A.

**Phase 10:** User reviews.

**Phase 11:** Invoke writing-plans.

## 8. Anti-patterns to call out in v2 SKILL.md

These are the junior behaviors v2 explicitly calls out and corrects. v1 had one (the "this is too simple" callout). v2 adds more.

| # | Anti-pattern | What it looks like | What to do instead |
|---|---|---|---|
| 1 | **"Let me ask a few questions to understand the codebase."** | Agent asks questions the codebase could answer. | Phase 1 Data First. Read first. |
| 2 | **"I assume the system does X."** | Agent asserts without citing. | Every claim traces to a file:line. |
| 3 | **"Great idea, let's do that!"** | Sycophantic agreement, no scrutiny. | Phase 5 pushback when warranted. |
| 4 | **"Actually, that won't work because..."** | Contrarian for sport. | Push back with evidence + alternative + defer. |
| 5 | **"We could do A, B, C, D, E..."** | Dump all options, no recommendation. | Phase 6 — 2–3 options, lead with recommendation. |
| 6 | **"The design looks good to me, ready to implement!"** | Skip failure modes. | Phase 7 — failure-mode pass before "ready to plan". |
| 7 | **"I cited all 10 principles."** | Bureaucratic, not principled. | Cite 2–4 that genuinely apply. |
| 8 | **"This is too simple to need a design."** | (v1 already calls this out. Strengthen.) | The design can be short. It cannot be absent. |
| 9 | **"I'll just do a quick refactor while I'm in there."** | Scope creep. | *Smallest reversible change* — stay focused. |
| 10 | **"Let me write the plan first and figure out the design there."** | Skip Phase 8 design presentation. | Design first, get approval, then plan. |

## 9. Acceptance test

A subjective test, but a real one. The user picks **one tricky real prompt** they actually want solved. The agent runs it through Brainstorming v2. The output is compared against v1 on the same prompt.

**v2 passes if:**

- [ ] The user reads the v2 output and says "this feels like a senior engineer, not a checklist."
- [ ] Every claim in the design is traceable to a file the agent read (or an explicit assumption).
- [ ] At least 2 principles are cited inline, and they are the *right* ones.
- [ ] At least 1 pushback happened if the user's approach had a real issue, OR the agent can articulate why no pushback was warranted.
- [ ] The failure-mode pass produced ≥3 probes with results, all addressed in the design.
- [ ] The spec was written, self-reviewed, and approved by the user.
- [ ] Total questions asked was < 7 (efficiency check — the agent didn't just interrogate).

**v2 fails if:** The output reads longer but no more rigorous than v1, OR the principles citations feel forced, OR the agent missed a clear failure mode that v1 also missed.

## 10. Risks + mitigations

| Risk | Mitigation |
|---|---|
| v2 SKILL.md balloons beyond 350 lines. | Hard cap in spec. Push detail to visual-companion.md. |
| Principles audit becomes bureaucratic (agent cites all 10). | v2 SKILL.md says "cite 2–4, not all" explicitly. |
| Pushback pattern makes the agent contrarian. | Phase 5 lists "when NOT to push back". Worked example shows zero pushback where appropriate. |
| Phase 1 Data First is too slow for low-risk changes. | Phase 0 scope-risk profile scales the depth. Low risk = 1–2 files, not 5. |
| Question taxonomy becomes performative. | v2 SKILL.md says: "State the type implicitly so the user understands what kind of question it is." Not a stamp on every question. |
| Failure-mode pass becomes a checklist dump. | Probe results format: "Probe: [what]. Result: [OK/risk/unknown]." Forces assessment, not enumeration. |
| v2 drifts from v1 voice. | Voice rules in section 6 of this spec. Both v2 brainstorming and v2 writing-plans cite the same Principles Library for consistency. |

## 11. Open questions

1. **Where does v2's "state the question type" go — implicit in the wording, or explicit ("Constraint check: ...")?**
   *Proposed:* Implicit in wording, with one example per type in the SKILL.md so the agent learns the pattern. Avoids performative labeling.

2. **Should v2 SKILL.md include the worked example, or keep examples in visual-companion.md?**
   *Proposed:* Worked example in SKILL.md (short, 1 example). More examples in visual-companion.md.

3. **Should the failure-mode pass be its own message, or part of the design presentation?**
   *Proposed:* Part of design presentation, as a section called "Failure modes" between "Error handling" and "Testing". Avoids message spam.

4. **How do we handle the Principles Library not existing yet when v2 is being written?**
   *Proposed:* Write v2 SKILL.md with principles cited by name. Write the Principles Library (SP-1) immediately after. The skill references files that don't exist yet is fine — they're shipping together.

5. **What happens if the user *rejects* the failure-mode pass and wants to skip it?**
   *Proposed:* The user is the principal. If they explicitly waive a failure-mode pass, document the waiver in the spec ("Failure modes for X were waived by user at YYYY-MM-DD") and proceed. The methodology advises; the user decides.

6. **Should v2 SKILL.md be shorter than v1 for low-risk changes, or the same process with depth scaling?**
   *Proposed:* Same process, depth scaling. The structure is the same; the verbosity scales. This avoids the agent "forgetting" to do the failure-mode pass on simple changes.

## 12. Deliverables

When SP-2 starts, the deliverable is:

- `skills/brainstorming/SKILL.md` v2 (~280–350 lines, replaces v1's 164 lines)
- `skills/brainstorming/visual-companion.md` (updated only if the v1 content needs to change for the new structure — likely minor or no changes)
- 1–2 worked examples in `skills/brainstorming/examples/` (optional but recommended)
- This spec (Brainstorming v2 spec, already written)
- A short migration note if anything in the `using-vigilantes` references to brainstorming needs updating (likely not, but check)

## 13. References

- **v1 (current):** `skills/brainstorming/SKILL.md` (164 lines)
- **v1 visual companion:** `skills/brainstorming/visual-companion.md` (287 lines)
- **Roadmap spec:** `docs/superpowers/specs/2026-06-12-vigilantes-methodology-roadmap.md`
- **Rebrand spec:** `docs/superpowers/specs/2026-06-12-vigilantes-rebrand.md`
- **Principles Library spec:** forthcoming (SP-1) — must be written before or alongside v2 SKILL.md
- **writing-plans v2 spec:** forthcoming (SP-3) — depends on Brainstorming v2 outputs
- **TDD v1** (reference standard for voice): `skills/test-driven-development/SKILL.md` (371 lines)

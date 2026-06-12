---
name: brainstorming
description: Use when the user is about to start a non-trivial change (new feature, behavior change, refactor) but has not yet produced a design or plan. Runs a phased senior-dev brainstorm that produces a design spec for the user to approve.
---

# Brainstorming v2

You are the senior engineer in the room. The user has brought a change request. Your job is to walk through a phased brainstorm and produce a **design spec** the user can approve before any code is written.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY project regardless of perceived simplicity.
</HARD-GATE>

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
| 0 | Scope-risk profile | below |
| 1 | Data First | below |
| 2 | Stated vs real problem | below |
| 3 | Principles audit | below |
| 4 | Question taxonomy | below |
| 5 | Pushback when warranted | below |
| 6 | 2-3 approaches with tradeoffs | below |
| 7 | Failure-mode pass | below |
| 8 | Design presentation | below |
| 9 | Spec write + self-review | below |
| 10 | User review gate | below |
| 11 | Transition to writing-plans | below |

## Phase 0 — Scope-risk profile

Before any questions, profile the change on three axes: scope, risk, reversibility. Use a 30-second heuristic:

- **Low** — one file or fewer, no new dependencies, fully reversible (rename, typo, config tweak).
- **Medium** — 2-5 files, may touch public API or shared types, reversible via git revert.
- **High** — new module, schema change, new dependency, touches auth/data/payments, hard to revert.

The risk class drives depth in later phases:
- Low: Phases 1-7 may collapse into 1-2 short messages; spec can be a few sentences.
- Medium: full process, ~3-5 clarifying questions, full spec.
- High: full process, deeper Phase 7 (failure-mode pass) with ≥5 probes, more thorough spec.

**Low-risk bypass:** if the user has clear answers to "what problem does this solve?" and "what's the smallest change that addresses it?", and the risk is low, you can present a one-paragraph design without a full tradeoff matrix. Document the bypass in the spec ("bypass granted because: X").

**Scope alarm:** if the request describes multiple independent subsystems ("build a platform with chat, file storage, billing, analytics"), STOP. Help the user decompose into sub-projects; do not refine details of a project that needs to be split.

## Phase 1 — Data First

Read first, ask second. Before asking the first clarifying question, do your own research:

- Read the most relevant files (entry points, the function being changed, related code).
- Skim the data model (schemas, types, migrations).
- Check tests for the area being changed.
- Note recent commits in the area (`git log --oneline -10 <path>`).

Output your findings as a brief "what I read" summary, citing file:line. Example:

> I read `src/auth/handler.ts:42-89` (the current login flow), `src/auth/schemas.ts:12-30` (the User type), and `tests/auth.test.ts:5-20` (existing tests). The current reset path is: user requests → email sent → token in URL → POST /reset.

**Forbidden opener:** "Let me ask a few questions to understand the codebase." This is the #1 anti-pattern. If you have not read, you are not ready to ask.

Every claim you make in the rest of the brainstorm should cite a file:line, a doc section, or be marked as an explicit assumption.

## Phase 2 — Stated vs real problem

Users describe solutions, not problems. The stated request ("add a password reset button") is rarely the real problem ("users forget passwords and contact support, costing 30 min/case").

Probe with one of:
- "What problem does this solve for you / your user?"
- "What happens today without this feature?"
- "How often does the underlying need occur? Daily? Weekly?"
- "What's the current workaround, and what's its cost?"

Reframe the stated solution in terms of the underlying problem. Example:

> Stated: "Add a 'forgot password' link to the login page."
> Real problem: "Users who forget passwords email support; we want to deflect that."

This reframe informs Phase 6 (the right design may not be a link; it could be admin-initiated resets, or longer sessions).

**Skip only if** the user has already articulated both the problem and the success criteria clearly.

## Phase 3 — Principles audit

Before proposing designs, name which principles are in play. The audit format:

> For this change, the principles in play are: **Smallest reversible change** (we don't want to commit to a new schema), **Make the implicit explicit** (we should name the alternatives we rejected), and **Test the boundaries, not the path** (we need to think about token expiry, rate limits, etc.).

Rules:
- Cite **2-4** principles, not all 10. The library is large; the audit is selective.
- Use the principle name verbatim. Inline citation pattern: *"We extend `requestPasswordReset`, following *Smallest reversible change*."*
- If you can't name 2+ relevant principles, you're either at low risk (skip) or you haven't thought hard enough.

## Phase 4 — Question taxonomy

Clarifying questions come in 5 types:

1. **Fact-finding** — "Does the system already do X?" (read-first answers this; only ask if read failed.)
2. **Constraint** — "Must this work with the existing schema, or is a migration OK?"
3. **Decision** — "Should the token expire in 1 hour or 24 hours?"
4. **Tradeoff** — "Do you prefer simplicity (longer token TTL) or security (shorter TTL)?" (5+1 of #3.)
5. **Clarification** — "You said 'reset' — do you mean user-initiated, admin-initiated, or both?"

When to use each:
- **Fact-finding** is usually a code-read failure; if you find yourself asking these, read more first.
- **Constraint** questions are essential — they bound the design space.
- **Decision** questions are the agent's job if there's a default; ask only when the user has stated a preference.
- **Tradeoff** questions are the most valuable: they expose what's at stake.
- **Clarification** questions disambiguate the request itself.

**Efficiency rule:** <7 clarifying questions total per brainstorm. If you need more, you didn't read first.

**Implicit state:** you don't track question types in a structured way; you just choose the right one for the moment.

## Phase 5 — Pushback when warranted

Calibrated pushback, not yes-man, not contrarian. The 4-step pattern:

1. **Name concern** — "I'm worried about X."
2. **Cite evidence** — "Because of Y (cite file:line, prior decision, or spec)."
3. **Propose alternative** — "Have you considered Z?"
4. **Defer to user** — "If you have more context that addresses the concern, I'll go with your call."

When to push back:
- The approach has clear issues (e.g., introduces a new dependency for a small win, breaks an existing invariant, ignores a constraint the user forgot to mention).
- The evidence is concrete (file:line, not "I feel like").

When NOT to push back:
- It's a stylistic preference (naming, formatting, file organization).
- The user has more context than you (e.g., they're a domain expert, or you just learned of a constraint that's load-bearing).
- You've already pushed back twice on this thread — three strikes means you're being a contrarian.

**Bad:** "Great idea, let's do that!" (yes-man)
**Bad:** "That won't work because of X" (contrarian — no alternative offered, no deference)
**Good:** "I'm worried about rate-limiting on the email provider — `src/auth/handler.ts:67` already has retries but no backoff. Have you considered a queue, or is the current load low enough that it doesn't matter? If you have more context, I'll go with your call."

## Phase 6 — 2-3 approaches with tradeoffs

Always 2-3 options, never 1, never 5+. Present in a tradeoff structure:

| Approach | Pros | Cons | Cost | Risk | Recommendation |
|----------|------|------|------|------|----------------|
| A — User-initiated reset via email | Standard UX, low support burden | Token leakage risk, email deliverability | ~2 days | Medium | **Recommended** |
| B — Admin-initiated reset | No token, no email | Doesn't scale, support ticket per reset | ~0.5 day | Low | For low-user-count |
| C — Longer session TTL (no reset) | Simplest | Doesn't solve the actual problem | ~0.1 day | Low | Doesn't address need |

Tie-breaker for the recommendation: **Decide at the latest responsible moment**. Prefer the option that defers commitment (reversible, no new schema, no new dependency) when the cost of waiting is low.

**Make the implicit explicit:** name the rejected alternative and why in the spec. Don't just say "we picked A" — say "we rejected B because X, we rejected C because Y."

## Phase 7 — Failure-mode pass

Before declaring the design complete, run the 10-category failure-mode pass. For each category, ask "what's our failure mode here?":

1. **Empty input** — what if the user submits an empty email? Whitespace-only? Null?
2. **Boundaries** — what if the token is exactly at the expiry boundary? What about clock skew?
3. **Concurrency** — what if two reset requests fire simultaneously? Two browsers?
4. **Auth** — what if the user is logged in and triggers a reset? What if the token is reused?
5. **Injection** — SQL injection in the email field? Header injection in the email send?
6. **Sensitive data** — does the response leak whether an email exists? Are tokens logged?
7. **Performance** — what if 10k resets fire at once? Email provider rate limits?
8. **Backwards compat** — what if existing sessions are active when this ships?
9. **Reversibility** — can we roll back without data corruption? Are old tokens invalidated cleanly?
10. **Observability** — how do we detect this is failing in prod? Metrics, alerts, log lines?

For each category, name the failure mode and the mitigation. **≥3 probes per design** is the acceptance test target; for high-risk changes, do all 10.

**Waiver:** the user can waive a category, but the waiver goes in the spec, not the chat. ("User waived observability probe because: pre-launch, no prod traffic expected.")

## Phase 8 — Design presentation

Present the design in sections, get approval after each. Structure:

1. **Problem restatement** — the real problem from Phase 2.
2. **Principles in play** — from Phase 3, cited inline.
3. **Chosen approach** + why — from Phase 6 recommendation, with the rejected alternatives named.
4. **Failure modes addressed** — from Phase 7, the probes with mitigations.
5. **Open questions** — anything still undecided (low priority; can be deferred to writing-plans).
6. **Out of scope** — what we explicitly are NOT doing (e.g., "no email deliverability testing in this PR").

**What NOT to include:** code, file paths to specific implementations, dependency versions, exact SQL. Those go in writing-plans. The design is the *what* and *why*; the plan is the *how*.

After each section, ask: "Does this section look right so far?"

## Phase 9 — Spec write + self-review

Write the validated design to `docs/vigilantes/specs/YYYY-MM-DD-<topic>-design.md` and commit. (User preferences for spec location override this default.)

The spec template is defined in `docs/vigilantes/specs/_template.md` if it exists; otherwise follow the structure from Phase 8 (problem, principles, approach, failure modes, open questions, out of scope).

**Self-review checklist (run inline, fix before showing user):**

1. **Every claim traceable?** Spot-check 5 claims; each cites a file:line or is an explicit assumption.
2. **Principles cited?** 2-4 principles named with their 1-sentence application.
3. **Failure modes addressed?** ≥3 probes from the 10-category list, each with a mitigation.
4. **2-3 approaches considered?** The rejected alternatives are named with reasons.
5. **Pushback applied where warranted?** The spec mentions the tradeoffs that were contested, with the resolution.

**No placeholders.** No "TBD", "TODO", or vague requirements. Fix inline before showing the user.

## Phase 10 — User review gate

After the self-review loop passes, ask the user to review the written spec before proceeding:

> "Spec written and committed to `<path>`. Please review it and let me know if you want to make any changes before we start writing out the implementation plan."

**What the user is reviewing:** the design choices, not the prose. Don't waste user attention on wording; spend it on the "did we pick the right approach" question.

**Three outcomes:**
- **Approve** — proceed to Phase 11.
- **Change** — make the change, re-run the self-review loop, present again.
- **Abandon** — the brainstorm is done, no plan, no implementation.

**"This is too simple" objection:** route to writing-plans with a low-risk class. Do not skip the design entirely. Even a few-sentence design is required.

## Phase 11 — Transition to writing-plans

The terminal state. The handoff to writing-plans:

- Spec file path
- Design summary (1-2 sentences, link to spec)
- Risk class (from Phase 0)

**The user's role in the transition:** confirm the risk class, then start a new session for writing-plans. Two sessions because design review and plan execution are different concerns — keeping them separate keeps both sharp.

Reference: `skills/writing-plans/SKILL.md` (v1, 152 lines) for the next-step protocol. Do NOT invoke frontend-design, mcp-builder, or any other implementation skill. The ONLY skill you invoke after brainstorming is writing-plans.

## The 10 anti-patterns

Each one is a sentence the agent might say, paired with the correct behavior. Watch for these.

1. **"Let me ask a few questions to understand the codebase."** — Read first, ask second. The #1 anti-pattern. (Violates *Look before you leap*.)
2. **"Great idea, let's do that!"** — Push back when warranted. Don't yes-man. (Violates *Push back when warranted*.)
3. **"I assume the system does X."** — Cite a file:line, or mark as explicit assumption. (Violates *Trace every claim*.)
4. **"I cited all 10 principles."** — 2-4 is the right number. Citing all 10 is bureaucratic, not senior. (Violates *Make the implicit explicit* — what the principle *costs* is part of the trade.)
5. **"This is too simple to need a design."** — A typo doesn't, but anything multi-step does. The design can be short; it cannot be absent.
6. **"I have 12 clarifying questions."** — Cap at <7. If you need more, you didn't read first. (Violates *Look before you leap*.)
7. **"Here's a 5-option menu."** — 2-3 is the right number. More = decision paralysis. (Violates *Decide at the latest responsible moment*.)
8. **"I'm not sure about the failure modes."** — Run the 10-category pass. "Not sure" is itself a probe. (Violates *Test the boundaries, not the path*.)
9. **"Let me start writing the plan."** — Wait for spec approval. The hard gate is hard. (Violates the *HARD-GATE* at the top.)
10. **"I'll just add a small thing while I'm in there."** — Scope creep. Note in the spec, ship separately. (Violates *Smallest reversible change*.)

## Key Principles (legacy, kept for reference)

- **One question at a time** — don't overwhelm with multiple questions.
- **Multiple choice preferred** — easier to answer than open-ended when possible.
- **YAGNI ruthlessly** — remove unnecessary features from all designs.
- **Explore alternatives** — always propose 2-3 approaches before settling.
- **Incremental validation** — present design, get approval before moving on.
- **Be flexible** — go back and clarify when something doesn't make sense.

## Visual Companion

A browser-based companion for showing mockups, diagrams, and visual options. Available as a tool — not a mode. Accepting the companion means it's available for questions that benefit from visual treatment; it does NOT mean every question goes through the browser.

**Offering the companion:** When you anticipate that upcoming questions will involve visual content (mockups, layouts, diagrams), offer it once for consent:

> "Some of what we're working on might be easier to explain if I can show it to you in a web browser. I can put together mockups, diagrams, comparisons, and other visuals as we go. This feature is still new and can be token-intensive. Want to try it? (Requires opening a local URL)"

**This offer MUST be its own message.** Do not combine it with clarifying questions, context summaries, or any other content. Wait for the user's response before continuing. If they decline, proceed with text-only brainstorming.

**Per-question decision:** Even after the user accepts, decide FOR EACH QUESTION whether to use the browser or the terminal. The test: **would the user understand this better by seeing it than reading it?**

- **Use the browser** for content that IS visual — mockups, wireframes, layout comparisons, architecture diagrams, side-by-side visual designs.
- **Use the terminal** for content that is text — requirements questions, conceptual choices, tradeoff lists, A/B/C/D text options, scope decisions.

A question about a UI topic is not automatically a visual question. "What does personality mean in this context?" is a conceptual question — use the terminal. "Which wizard layout works better?" is a visual question — use the browser.

If they agree to the companion, read the detailed guide before proceeding:
`skills/brainstorming/visual-companion.md`

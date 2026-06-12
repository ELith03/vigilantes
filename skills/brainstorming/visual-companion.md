# Visual Companion Guide

Browser-based visual brainstorming companion for showing mockups, diagrams, and options.

## When to Use

Decide per-question, not per-session. The test: **would the user understand this better by seeing it than reading it?**

**Use the browser** when the content itself is visual:

- **UI mockups** — wireframes, layouts, navigation structures, component designs
- **Architecture diagrams** — system components, data flow, relationship maps
- **Side-by-side visual comparisons** — comparing two layouts, two color schemes, two design directions
- **Design polish** — when the question is about look and feel, spacing, visual hierarchy
- **Spatial relationships** — state machines, flowcharts, entity relationships rendered as diagrams

**Use the terminal** when the content is text or tabular:

- **Requirements and scope questions** — "what does X mean?", "which features are in scope?"
- **Conceptual A/B/C choices** — picking between approaches described in words
- **Tradeoff lists** — pros/cons, comparison tables
- **Technical decisions** — API design, data modeling, architectural approach selection
- **Clarifying questions** — anything where the answer is words, not a visual preference

A question *about* a UI topic is not automatically a visual question. "What kind of wizard do you want?" is conceptual — use the terminal. "Which of these wizard layouts feels right?" is visual — use the browser.

## How It Works

The server watches a directory for HTML files and serves the newest one to the browser. You write HTML content to `screen_dir`, the user sees it in their browser and can click to select options. Selections are recorded to `state_dir/events` that you read on your next turn.

**Content fragments vs full documents:** If your HTML file starts with `<!DOCTYPE` or `<html`, the server serves it as-is (just injects the helper script). Otherwise, the server automatically wraps your content in the frame template — adding the header, CSS theme, selection indicator, and all interactive infrastructure. **Write content fragments by default.** Only write full documents when you need complete control over the page.

## Starting a Session

```bash
# Start server with persistence (mockups saved to project)
scripts/start-server.sh --project-dir /path/to/project

# Returns: {"type":"server-started","port":52341,"url":"http://localhost:52341",
#           "screen_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/content",
#           "state_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/state"}
```

Save `screen_dir` and `state_dir` from the response. Tell user to open the URL.

**Finding connection info:** The server writes its startup JSON to `$STATE_DIR/server-info`. If you launched the server in the background and didn't capture stdout, read that file to get the URL and port. When using `--project-dir`, check `<project>/.superpowers/brainstorm/` for the session directory.

**Note:** Pass the project root as `--project-dir` so mockups persist in `.superpowers/brainstorm/` and survive server restarts. Without it, files go to `/tmp` and get cleaned up. Remind the user to add `.superpowers/` to `.gitignore` if it's not already there.

**Launching the server by platform:**

**Claude Code (macOS / Linux):**
```bash
# Default mode works — the script backgrounds the server itself
scripts/start-server.sh --project-dir /path/to/project
```

**Claude Code (Windows):**
```bash
# Windows auto-detects and uses foreground mode, which blocks the tool call.
# Use run_in_background: true on the Bash tool call so the server survives
# across conversation turns.
scripts/start-server.sh --project-dir /path/to/project
```
When calling this via the Bash tool, set `run_in_background: true`. Then read `$STATE_DIR/server-info` on the next turn to get the URL and port.

**Codex:**
```bash
# Codex reaps background processes. The script auto-detects CODEX_CI and
# switches to foreground mode. Run it normally — no extra flags needed.
scripts/start-server.sh --project-dir /path/to/project
```

**Gemini CLI:**
```bash
# Use --foreground and set is_background: true on your shell tool call
# so the process survives across turns
scripts/start-server.sh --project-dir /path/to/project --foreground
```

**Other environments:** The server must keep running in the background across conversation turns. If your environment reaps detached processes, use `--foreground` and launch the command with your platform's background execution mechanism.

If the URL is unreachable from your browser (common in remote/containerized setups), bind a non-loopback host:

```bash
scripts/start-server.sh \
  --project-dir /path/to/project \
  --host 0.0.0.0 \
  --url-host localhost
```

Use `--url-host` to control what hostname is printed in the returned URL JSON.

## The Loop

1. **Check server is alive**, then **write HTML** to a new file in `screen_dir`:
   - Before each write, check that `$STATE_DIR/server-info` exists. If it doesn't (or `$STATE_DIR/server-stopped` exists), the server has shut down — restart it with `start-server.sh` before continuing. The server auto-exits after 30 minutes of inactivity.
   - Use semantic filenames: `platform.html`, `visual-style.html`, `layout.html`
   - **Never reuse filenames** — each screen gets a fresh file
   - Use Write tool — **never use cat/heredoc** (dumps noise into terminal)
   - Server automatically serves the newest file

2. **Tell user what to expect and end your turn:**
   - Remind them of the URL (every step, not just first)
   - Give a brief text summary of what's on screen (e.g., "Showing 3 layout options for the homepage")
   - Ask them to respond in the terminal: "Take a look and let me know what you think. Click to select an option if you'd like."

3. **On your next turn** — after the user responds in the terminal:
   - Read `$STATE_DIR/events` if it exists — this contains the user's browser interactions (clicks, selections) as JSON lines
   - Merge with the user's terminal text to get the full picture
   - The terminal message is the primary feedback; `state_dir/events` provides structured interaction data

4. **Iterate or advance** — if feedback changes current screen, write a new file (e.g., `layout-v2.html`). Only move to the next question when the current step is validated.

5. **Unload when returning to terminal** — when the next step doesn't need the browser (e.g., a clarifying question, a tradeoff discussion), push a waiting screen to clear the stale content:

   ```html
   <!-- filename: waiting.html (or waiting-2.html, etc.) -->
   <div style="display:flex;align-items:center;justify-content:center;min-height:60vh">
     <p class="subtitle">Continuing in terminal...</p>
   </div>
   ```

   This prevents the user from staring at a resolved choice while the conversation has moved on. When the next visual question comes up, push a new content file as usual.

6. Repeat until done.

## Writing Content Fragments

Write just the content that goes inside the page. The server wraps it in the frame template automatically (header, theme CSS, selection indicator, and all interactive infrastructure).

**Minimal example:**

```html
<h2>Which layout works better?</h2>
<p class="subtitle">Consider readability and visual hierarchy</p>

<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>Single Column</h3>
      <p>Clean, focused reading experience</p>
    </div>
  </div>
  <div class="option" data-choice="b" onclick="toggleSelect(this)">
    <div class="letter">B</div>
    <div class="content">
      <h3>Two Column</h3>
      <p>Sidebar navigation with main content</p>
    </div>
  </div>
</div>
```

That's it. No `<html>`, no CSS, no `<script>` tags needed. The server provides all of that.

## CSS Classes Available

The frame template provides these CSS classes for your content:

### Options (A/B/C choices)

```html
<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>Title</h3>
      <p>Description</p>
    </div>
  </div>
</div>
```

**Multi-select:** Add `data-multiselect` to the container to let users select multiple options. Each click toggles the item. The indicator bar shows the count.

```html
<div class="options" data-multiselect>
  <!-- same option markup — users can select/deselect multiple -->
</div>
```

### Cards (visual designs)

```html
<div class="cards">
  <div class="card" data-choice="design1" onclick="toggleSelect(this)">
    <div class="card-image"><!-- mockup content --></div>
    <div class="card-body">
      <h3>Name</h3>
      <p>Description</p>
    </div>
  </div>
</div>
```

### Mockup container

```html
<div class="mockup">
  <div class="mockup-header">Preview: Dashboard Layout</div>
  <div class="mockup-body"><!-- your mockup HTML --></div>
</div>
```

### Split view (side-by-side)

```html
<div class="split">
  <div class="mockup"><!-- left --></div>
  <div class="mockup"><!-- right --></div>
</div>
```

### Pros/Cons

```html
<div class="pros-cons">
  <div class="pros"><h4>Pros</h4><ul><li>Benefit</li></ul></div>
  <div class="cons"><h4>Cons</h4><ul><li>Drawback</li></ul></div>
</div>
```

### Mock elements (wireframe building blocks)

```html
<div class="mock-nav">Logo | Home | About | Contact</div>
<div style="display: flex;">
  <div class="mock-sidebar">Navigation</div>
  <div class="mock-content">Main content area</div>
</div>
<button class="mock-button">Action Button</button>
<input class="mock-input" placeholder="Input field">
<div class="placeholder">Placeholder area</div>
```

### Typography and sections

- `h2` — page title
- `h3` — section heading
- `.subtitle` — secondary text below title
- `.section` — content block with bottom margin
- `.label` — small uppercase label text

## Browser Events Format

When the user clicks options in the browser, their interactions are recorded to `$STATE_DIR/events` (one JSON object per line). The file is cleared automatically when you push a new screen.

```jsonl
{"type":"click","choice":"a","text":"Option A - Simple Layout","timestamp":1706000101}
{"type":"click","choice":"c","text":"Option C - Complex Grid","timestamp":1706000108}
{"type":"click","choice":"b","text":"Option B - Hybrid","timestamp":1706000115}
```

The full event stream shows the user's exploration path — they may click multiple options before settling. The last `choice` event is typically the final selection, but the pattern of clicks can reveal hesitation or preferences worth asking about.

If `$STATE_DIR/events` doesn't exist, the user didn't interact with the browser — use only their terminal text.

## Design Tips

- **Scale fidelity to the question** — wireframes for layout, polish for polish questions
- **Explain the question on each page** — "Which layout feels more professional?" not just "Pick one"
- **Iterate before advancing** — if feedback changes current screen, write a new version
- **2-4 options max** per screen
- **Use real content when it matters** — for a photography portfolio, use actual images (Unsplash). Placeholder content obscures design issues.
- **Keep mockups simple** — focus on layout and structure, not pixel-perfect design

## File Naming

- Use semantic names: `platform.html`, `visual-style.html`, `layout.html`
- Never reuse filenames — each screen must be a new file
- For iterations: append version suffix like `layout-v2.html`, `layout-v3.html`
- Server serves newest file by modification time

## Cleaning Up

```bash
scripts/stop-server.sh $SESSION_DIR
```

If the session used `--project-dir`, mockup files persist in `.superpowers/brainstorm/` for later reference. Only `/tmp` sessions get deleted on stop.

## Reference

- Frame template (CSS reference): `scripts/frame-template.html`
- Helper script (client-side): `scripts/helper.js`

---

## V2 Worked Example: "Add password reset to the login page"

A single walkthrough of brainstorming v2 applied to a real prompt. Shows the senior-dev pattern: read first, probe, push back when warranted, propose 2-3 options, fail-mode pass, then spec. All 11 phases in order.

> **User prompt:** "I need to add a password reset to the login page. Can you help?"

### Phase 0 — Scope-risk profile

> 30-second heuristic: scope = small (single feature, well-known pattern). Risk = medium (auth surface, security implications, email deliverability, user enumeration, rate limiting).

Risk = medium, not low. Even a "simple" password reset has security implications. We will run all 11 phases; we will not skip the failure-mode pass.

### Phase 1 — Data First

> Read before asking. Cite files.

Before saying anything, read:
- `src/auth/login.ts` — current login flow, password handling
- `src/auth/users.ts` — user model, hashing
- `src/mail/send.ts` — email sender
- `package.json` — confirm bcrypt, jwt, prisma already installed
- `tests/auth/login.test.ts` — current test patterns

What I find (cited):
- Login is at `src/auth/login.ts:42`, uses bcrypt with cost 12
- Email sender at `src/mail/send.ts:18` supports templates
- Tests use vitest + supertest, mock external services in `tests/mocks/`
- No existing token/reset primitives — this is greenfield

### Phase 2 — Stated vs real problem

> The user asked for "password reset." What do they actually need?

The stated problem: a reset link flow.
Probable real problem: a recovery path that doesn't compromise the existing login. Sub-probes:
- Are they worried about support tickets for locked-out users? (likely yes)
- Is there a current workaround? (maybe manual SQL reset)
- What's the rollout expectation — internal first, or production on day one?

I ask the user the support-tickets sub-probe (the one that most shapes the design).

> "Is the main pain user lockouts, or is it security-driven (compelled rotation, breach response)?"

User answer: "User lockouts. About 15 tickets a week."

### Phase 3 — Principles audit

> Cite 2-4 principles, not all 10.

Inline citations in my next message:
- Following *Look before you leap* (read codebase first) — done in Phase 1.
- Following *Make the implicit explicit* — a "reset link" hides: token entropy, expiration, single-use enforcement, rate limiting, user enumeration resistance.
- Following *Test the boundaries, not the path* — happy path is easy; the security tests (expired token, reused token, rate limit, enumeration) are where the design is judged.

That's 3. Not 10. Per principle #4 (Pick the right tool for the job — i.e. don't overcite), 2-4 is right.

### Phase 4 — Question taxonomy

> 5 types: fact-finding, constraint, decision, tradeoff, clarification. Aim for <7 total.

I have 2 questions so far (one in Phase 2 + the answered support-tickets probe). I add 2 more:

1. **Constraint:** "Email-only, or SMS fallback too?" (constraint)
2. **Tradeoff:** "Token validity window — 15 min (more secure) or 1 hour (fewer support tickets)?" (tradeoff)

That's 4 total. Under the 7-question cap.

### Phase 5 — Pushback when warranted

> 4-step: name concern → cite evidence → propose alternative → defer to user.

The user said "to the login page" in their prompt. I notice there's no clear placement reason — the reset is its own flow, not a sub-feature of login. I push back:

> "Worth questioning: should the reset UI live on the login page, or get its own `/forgot` route? Putting it on login mixes recovery and primary auth, makes the login screen busier, and makes the reset link shareable from the login page. Cleaner is a dedicated `/forgot` (request) and `/reset?token=...` (confirm) flow. Tradeoff: two extra routes to maintain. Want me to do `/forgot` or do you have a reason it has to live on login?"

The user agrees to the dedicated routes. Pushback was warranted (mixed concerns) and I cited a reason (cleaner separation).

### Phase 6 — 2-3 approaches with tradeoffs

> 5-col table: Approach, Pros, Cons, Cost, Risk.

| Approach | Pros | Cons | Cost | Risk |
|---|---|---|---|---|
| **A. Signed token in URL, single table column** | Simplest. Self-contained. No email infra changes. | Token in URL can leak via referrer headers. | ~4h | Medium — referrer leak on shared devices |
| **B. Opaque token in URL, hashed at rest** | Server stores only hash. URL token alone is useless to attacker. | Slightly more code (hash on store + compare). | ~6h | Low — best practice |
| **C. OTP code via email, no link** | No URL leak. Works without clicking a link. | Bad UX on mobile email clients. No atomic confirm step. | ~5h | Medium — UX friction |

Recommendation: **B**. Standard, secure, modest extra cost. The `bcrypt`-style hash we already use for passwords can hash the token.

> Tie-breaker (per *Decide at the latest responsible moment*): I've picked B, but if the user has a constraint that disqualifies B (e.g. "we use DynamoDB and don't want column additions"), we revisit.

### Phase 7 — Failure-mode pass

> 10 categories. Run all; flag ≥3 concrete probes.

| Category | Probe | Mitigation |
|---|---|---|
| Empty input | User submits form with no email | Reject client-side + server-side |
| Boundaries | Email with leading/trailing whitespace | Trim + lowercase before lookup |
| Concurrency | Two parallel requests, one token consumed twice | Mark token used atomically (UPDATE ... WHERE used=false) |
| Auth | User who never requested reset receives an email | Don't reveal whether email exists — return same success message regardless |
| Injection | Token contains SQL/HTML chars | Tokens are random hex; we hash them, so we never query by raw token |
| Sensitive data | Token in logs | Sanitize token from logs; never log query params |
| Performance | Brute-force the 32-byte token | Token is 32 bytes (256 bits) — unguessable |
| Backwards compat | Existing user without email | Reject gracefully; suggest contacting support |
| Reversibility | User resets and immediately regrets | Already happens with normal password change; out of scope |
| Observability | Reset attempts spike (attack?) | Add metric: reset request count, reset completion count, delta |

That produced 10 probes — way more than 3 — and 1 metric (observability).

### Phase 8 — Design presentation

> 6 components, no code, sections approval.

**Components:**
1. **DB schema** — new `password_reset_tokens` table: `id`, `user_id`, `token_hash`, `expires_at`, `used_at`, `created_at`.
2. **API** — `POST /forgot` (request), `POST /reset` (confirm), `GET /reset?token=...` (validate page).
3. **Email template** — single template with reset URL.
4. **UI** — `/forgot` page, `/reset` page; both reuse the existing form components.
5. **Rate limit** — 3 requests / 15 min / IP, 3 requests / hour / email.
6. **Tests** — happy path, expired token, reused token, wrong email (silent), rate limit, enumeration probe.

User approves. No code yet.

### Phase 9 — Spec write + self-review

> Write spec to `docs/vigilantes/specs/...` with 5-item checklist.

Spec is now in `docs/vigilantes/specs/2026-06-13-password-reset.md`. Self-review:
- [x] No "TBD" / "fill in later" placeholders
- [x] Every component from Phase 8 maps to a spec section
- [x] Every failure-mode probe from Phase 7 is addressed
- [x] Principles cited (Look before you leap, Make the implicit explicit, Test the boundaries)
- [x] Acceptance criteria for the 6 test cases listed in Phase 8

### Phase 10 — User review gate

> 3 outcomes: approve, change, abandon.

User reads spec, replies: "Approve. One change: add audit log for the reset event."

I update the spec (add `audit_log` table write in the confirm step) and re-confirm. Approved.

### Phase 11 — Transition to writing-plans

> Handoff to writing-plans.

"Spec approved. To build this, I'll invoke the writing-plans skill. In a fresh session (per the v2 writing-plans handoff), the agent will read this spec and produce a bite-sized implementation plan. Should I open that session now, or do you want to review the spec once more?"

User: "Go."

Terminal state. Brainstorming v2 is done for this feature.

---

## V2 anti-patterns: what NOT to do (real examples)

> Anti-patterns from the SKILL.md, with concrete bad responses.

| Anti-pattern | Bad response (do NOT do this) | Better response |
|---|---|---|
| "Let me ask a few questions" | "Before I start, can you tell me about your auth system?" | Read `src/auth/` first; cite what you found; ask only what's left. |
| "Great idea!" | "Great idea! Let me build the reset flow." | "Two concerns before I scope this: (1) email enumeration risk if we reveal whether the email exists, (2) token in URL can leak via referrer. Want me to design with those in mind?" |
| "I assume..." | "I assume you use bcrypt for passwords." | "Login uses bcrypt cost 12 at `src/auth/login.ts:42`. I'll match that for token hashing." |
| "I cited all 10 principles" | Dump all 10 principles in one block | Cite 2-4 that genuinely apply to this phase. |
| "Too simple to need design" | "It's a small feature, let me just code it." | Risk assessment in Phase 0 — auth surfaces are never "small." |
| "12 clarifying questions" | Fire 10+ questions in one message | Cap at <7. Batch. Defer non-blockers. |
| "5-option menu" | "Should we do email, SMS, security questions, authenticator, or password manager?" | 2-3 options. Compare. Recommend. |
| "Not sure about failure modes" | Skip the failure-mode pass for "speed" | Run all 10 categories. Flag ≥3 concrete probes. |
| "Let me start writing the plan" | Start coding before spec approval | Wait for Phase 10 user approval gate. |
| "Just add a small thing" | "Oh also add 2FA while you're at it" | Scope creep — flag it. New feature = new brainstorming session. |

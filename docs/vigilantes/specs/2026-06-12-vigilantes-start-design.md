# Design Spec: `/vigilantes:start` — State-Aware Entry Point

**Date:** 2026-06-12
**Author:** ELith03 (opencode assistant)
**Risk class:** Low
**Status:** Draft

## Problem restatement

The vigilantes plugin (fork of `obra/superpowers`) ships 14 skills, but new users — and the author in a fresh session — cannot recall what order to use them in, where to start, or what state they last left a project in. Each new chat session starts with "0 memory," and the only top-level docs are `README.md` and `METHODOLOGY.md` — neither is a sticky step-by-step flow map. The current entry point is `using-vigilantes` (a runtime gate that says "use skills first"), which does not answer the "where do I begin?" question. Users land in the plugin and stall.

The success criteria for "done" is: in a fresh session, a user can ask for help and get a 3-option menu; on a second invocation with existing artifacts in the working directory, the user is routed to "continue from step N" (resume brainstorming, start writing-plans, etc.) without having to re-state their context.

## Principles in play

- **Look before you leap** — the entry point must inspect the working directory (existing specs, plans, branches) before asking the user what to do. Detect state; don't ask.
- **Make the implicit explicit** — surface the 3 high-level entry paths (new project, existing project, customize) as an explicit menu, not a vague "what do you want to do?" prompt.
- **Test the boundaries, not the path** — handle the 3 edge cases that would break naive state detection: no working directory, fresh repo (no artifacts), and a working directory with stray `docs/` that isn't vigilantes-formatted.

## Approach

The entry point lives as a new skill `vigilantes:start`. The skill is the single canonical entry; slash-command surfaces (`/vigilantes:start` in Claude Code + Cursor) are thin shims that invoke the skill by name. All 7 supported harnesses (Claude, Codex, Cursor, Copilot, Droid, Gemini, OpenCode) get the same flow because they all support the `Skill` tool — only 2 of them (Claude, Cursor) get the additional slash-command UX.

### Components

| Component | File | Role |
|---|---|---|
| **FLOW.md** | `FLOW.md` (new, top-level) | Canonical step-by-step flow map. Read by humans and by the `vigilantes-start` skill when the user asks "what comes next?" |
| **`vigilantes:start` skill** | `skills/vigilantes-start/SKILL.md` (new) | State-aware entry point. On invocation: (a) detect state, (b) show menu or resume path, (c) hand off to the appropriate next skill. |
| **Slash command shim** | `commands/vigilantes/start.md` (new) | Claude Code + Cursor: `/vigilantes:start` → invokes the skill. |
| **Claude manifest update** | `.claude-plugin/plugin.json` (update) | Add `"commands": "./commands/"` field. |
| **README update** | `README.md` (update) | New "How this fork differs" section + FLOW.md link. |
| **METHODOLOGY update** | `METHODOLOGY.md` (update) | One-line pointer at the top: "For the canonical step-by-step flow, see [FLOW.md](./FLOW.md)." |

### Data flow

**On `/vigilantes:start` invocation (skill or slash command):**

1. Skill body runs.
2. **State detection step.** Read working directory for:
   - `docs/vigilantes/specs/YYYY-MM-DD-*-design.md` files → user is mid-brainstorm or has approved specs.
   - `docs/vigilantes/plans/YYYY-MM-DD-*.md` files → user has a plan ready for execution.
   - `.worktrees/` presence → user is in an isolated worktree from `using-git-worktrees`.
   - `git status` clean + no artifacts → user is starting fresh.
3. **Route step.**
   - If spec files exist but no plan → "Looks like you have a spec at `<path>`. Next step is `vigilantes:writing-plans`. Want me to invoke it?"
   - If plan file exists → "Looks like you have a plan at `<path>`. Next step is `vigilantes:executing-plans` or `vigilantes:subagent-driven-development`."
   - If no artifacts → show the 3-option menu.
4. **Menu step** (only on fresh start):
   - **Option 1 — New project.** Walk through: brainstorming → writing-plans → executing.
   - **Option 2 — Existing project.** Detect the project type (from working dir contents) and recommend the right skill to start with.
   - **Option 3 — Explain in deep / customize.** Show the full skill library, link to `FLOW.md`, offer to walk through any skill.

### Error handling

| Failure | Class | Handling |
|---|---|---|
| Working dir not readable | Degraded | Fall back to "fresh start" menu; ask user to confirm working dir. |
| Spec/plan files exist but are malformed (not vigilantes-format) | Degraded | Warn user; offer to either (a) use the file as-is, (b) re-brainstorm, (c) ignore. |
| `FLOW.md` missing | Fatal | Stop; tell user the plugin is in a broken state and to reinstall. Should not happen in normal installs. |
| User invokes `/vigilantes:start` from outside a project directory | Degraded | Show a "you're not in a project" message + the install link from `README.md`. |

## Rejected alternatives

| Approach | Why rejected |
|---|---|
| **Auto-trigger `vigilantes:start` at session start (alongside `using-vigilantes`)** | Would inject menu noise on every session, even for users who know what they're doing. Violates "smallest reversible change" — adds a runtime surface that 95% of users don't need. |
| **Skip the slash command, skill-only** | Claude Code + Cursor users expect `/` discoverability. The slash command is a 1-line file; the UX win is large. |
| **Put FLOW.md in `/docs`** | `/docs` is templates-only post-cleanup. A flow map is human-facing reference, not a template. Top-level sibling of `README.md` makes it discoverable. |
| **Make `vigilantes:start` write to `docs/vigilantes/specs/` directly when no spec exists** | Violates the skill separation. Spec writing is `brainstorming`'s job. `vigilantes:start` routes; it doesn't generate. |
| **Detect state via a `vigilantes-state.json` file the user maintains** | Adds a runtime-write surface; one more file to forget; one more thing to break. Grepping the working dir is read-only and sufficient. |

## Failure modes addressed

| # | Category | Failure mode | Mitigation |
|---|---|---|---|
| 1 | Empty input | User invokes skill from a directory with no project files | Treat as "fresh start"; show 3-option menu; ask user to `cd` into a project if they have one. |
| 2 | Boundaries | Exactly 1 spec file vs. 5 spec files (multi-project?) | Treat any number ≥1 as "has specs"; show the most recent. Don't try to disambiguate multi-project — out of scope. |
| 3 | Concurrency | User has the skill running while files change | Read-once at invocation; don't watch. If state changes mid-conversation, next invocation re-detects. |
| 4 | Auth | N/A (no auth surface) | — |
| 5 | Injection | Spec/plan filenames could contain shell-injection chars (e.g., `; rm -rf`) | Never execute filenames as commands; treat as strings for display only. Skill body passes them as text, not as shell args. |
| 6 | Sensitive data | Working dir might contain secrets in spec/plan content | Skill only reads file *names*, not file *contents*. Never dumps spec content back to user. |
| 7 | Performance | Working dir with thousands of files | Use `find` with depth limits; cap at first 20 artifacts. Don't recurse into `node_modules/`, `.git/`. |
| 8 | Backwards compat | Existing users don't have `FLOW.md` or `vigilantes:start` yet | Both ship together in the same release; existing users get them on next `git pull`. Old entry pattern (just `using-vigilantes` injection) still works. |
| 9 | Reversibility | Removing `vigilantes:start` skill in a future version | Revert commit removes the skill + FLOW.md + command shim. No state file to clean. |
| 10 | Observability | User reports "the menu didn't show" | Skill body has clear `print` statements at each step; user can paste the output to debug. No metrics (this is local CLI behavior). |

## Open questions

- **Welcome timing (Q2 from prior round).** Deferred. The user said this needs the FLOW.md context to answer. After FLOW.md lands, revisit whether `vigilantes:start` should also fire on install (post-install hook) or only on user invocation. Current design: user-invocation only.
- **Cursor `agents/` directory.** Cursor's manifest declares it but no `agents/` dir exists. Not needed for `vigilantes:start`. Leave as a future-work item.

## Out of scope

- **Building new skills via `/vigilantes:start` (the "customize with LLM" path).** This is a separate feature with its own brainstorming round. The current design routes users to the existing `vigilantes:writing-skills` skill for that.
- **Auto-invocation at install time.** Welcome timing (Q2) deferred.
- **Multi-project detection.** If a working dir has 5 spec files, treat as "has specs, show most recent." Don't try to disambiguate.
- **i18n.** FLOW.md and the skill are English-only for v1. The plugin's existing docs are English-only; not regressing.
- **Cursor `agents/` directory.** Not needed for this feature.

## Verification

- [ ] `FLOW.md` exists at top level, contains a 5-step flow map (brainstorming → writing-plans → TDD → subagent-driven-development → finishing-a-development-branch), each step with a one-line "what you should have at the end" marker.
- [ ] `skills/vigilantes-start/SKILL.md` exists, has frontmatter (name, description with trigger condition), and body covers: state detection, 3-option menu, resume routing.
- [ ] `commands/vigilantes/start.md` exists with Claude Code slash-command frontmatter (`description`, `argument-hint`) and a body that delegates to the `vigilantes:start` skill.
- [ ] `.claude-plugin/plugin.json` includes `"commands": "./commands/"`.
- [ ] `README.md` has a "How this fork differs" section listing the 3 v2 additions (10-principle library, 11-phase brainstorming, 8-phase writing-plans) + a link to `FLOW.md`.
- [ ] `METHODOLOGY.md` has a one-line pointer at the top to `FLOW.md`.
- [ ] `hooks/session-start` and `.opencode/plugins/vigilantes.js` are **byte-for-byte unchanged** (verified via `git diff`).
- [ ] `using-vigilantes/SKILL.md` is **byte-for-byte unchanged** (verified via `git diff`).
- [ ] A fresh-session smoke test: in a directory with `docs/vigilantes/specs/2026-06-12-foo-design.md` present, invoking the skill surfaces the resume prompt for `vigilantes:writing-plans`.
- [ ] A fresh-session smoke test: in an empty directory, invoking the skill surfaces the 3-option menu.
- [ ] `git grep "FLOW.md"` returns expected references (none of the deleted paths reappear).

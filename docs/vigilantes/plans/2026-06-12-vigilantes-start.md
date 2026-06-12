# Plan: `/vigilantes:start` — State-Aware Entry Point

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a state-aware entry-point skill + slash command + FLOW map so a fresh session knows what to do.

**Architecture:** New `FLOW.md` (canonical flow map, read by humans and the new skill). New `vigilantes-start` skill reads the working dir for spec/plan files and either shows a 3-option menu (fresh start) or routes to the next-step skill (resume). Claude Code + Cursor also get a `/vigilantes:start` slash command as a thin shim invoking the skill. README and METHODOLOGY point to FLOW.md. Agent runtime surface (session-start hook, OpenCode plugin, using-vigilantes skill) is untouched.

**Tech Stack:** Markdown (FLOW.md, skill, slash command, README, METHODOLOGY), JSON (Claude manifest).

**Risk class:** Low (per `docs/vigilantes/specs/2026-06-12-vigilantes-start-design.md`).

**Design:** `docs/vigilantes/specs/2026-06-12-vigilantes-start-design.md`

**Date:** 2026-06-12

**Author:** ELith03 (opencode assistant)

## Principles in play

- **Look before you leap** — every new file is read in full before the next task starts; the verification step of Task 6 uses `git diff` to confirm the agent flow surface is byte-for-byte unchanged.
- **Smallest reversible change** — tasks are ordered so a partial-execution revert is clean: FLOW.md and the new skill are fully reversible via `git revert`; the README/METHODOLOGY edits are 1-line and trivially revertible.
- **Make the implicit explicit** — every file's *exact final content* is shown in the step's Code block. The implementer does not need to design; they paste and verify.

## Task

Implement the 6 deliverables from the design spec: FLOW.md, vigilantes-start skill, slash command shim, Claude manifest update, README update, METHODOLOGY update. After implementation, verify the agent's runtime flow surface is unchanged.

## Files to create / modify

- **Create** `FLOW.md` — top-level canonical flow map, 5 steps with "what you should have at the end" markers.
- **Create** `skills/vigilantes-start/SKILL.md` — state-aware entry-point skill. Frontmatter (name, description) + body (state detection, 3-option menu, resume routing).
- **Create** `commands/vigilantes/start.md` — Claude Code + Cursor slash command. Frontmatter (`description`, `argument-hint`) + body that invokes the `vigilantes-start` skill via the Skill tool.
- **Modify** `.claude-plugin/plugin.json` — add `"commands": "./commands/"` field.
- **Modify** `README.md` — add "How this fork differs" section + link to FLOW.md + clean up Community section (remove Discord + Release announcements, keep Issues).
- **Modify** `METHODOLOGY.md` — add one-line pointer at the top to FLOW.md.

## Step-by-step

### Task 1: Create FLOW.md

**Files:**
- Create: `FLOW.md`

- [ ] **Step 1.1: Write FLOW.md**

**File:** `FLOW.md`
**Code:**
```markdown
# Vigilantes Flow

The canonical step-by-step flow for the vigilantes methodology. Use this when
you land in a fresh session and need to know "what comes next?" — or invoke
the `vigilantes:start` skill and let it detect where you are.

This map is for the **user-project flow** (the work a developer does on a
project that uses vigilantes). The plugin's own internal skills (e.g.,
`vigilantes:using-vigilantes`, `vigilantes:start`) are not part of this map.

## The 5-step flow

| # | Step | Skill | What you should have at the end |
|---|------|-------|----------------------------------|
| 1 | **Brainstorm** the change | `vigilantes:brainstorming` | An approved design spec at `docs/vigilantes/specs/YYYY-MM-DD-<topic>-design.md` |
| 2 | **Plan** the implementation | `vigilantes:writing-plans` | An approved bite-sized plan at `docs/vigilantes/plans/YYYY-MM-DD-<feature>-plan.md` |
| 3 | **Execute** with TDD | `vigilantes:test-driven-development` + `vigilantes:executing-plans` (or `vigilantes:subagent-driven-development`) | Working code, all tests green, commit history clean |
| 4 | **Review** between tasks | `vigilantes:requesting-code-review` + (when reviewing others) `vigilantes:receiving-code-review` | Each task reviewed against the plan; critical issues fixed before continuing |
| 5 | **Finish** the branch | `vigilantes:finishing-a-development-branch` | A merged PR (or a decision: keep / discard / merge) |

## When to deviate

- **Bug fix on existing code?** Skip Step 1 (no spec needed for a 1-line fix). Go straight to Step 3 with `vigilantes:systematic-debugging` first.
- **Tiny cosmetic change?** Skip Steps 1, 2, 4. Step 3 only, with the TDD skill deciding whether a test is warranted.
- **Large feature with multiple independent subsystems?** Decompose at Step 1 — one spec per subsystem, then plan and execute each independently.
- **Picking up after a break?** Invoke `vigilantes:start` — it detects your state from the working directory and routes you to the right step.

## Related docs

- `README.md` — install + high-level overview.
- `METHODOLOGY.md` — the 10-principle library + skill catalog (the "voice" of the methodology).
- `docs/vigilantes/specs/_template.md` — template for new design specs (used by `vigilantes:brainstorming`).
- `docs/vigilantes/plans/_template.md` — template for new implementation plans (used by `vigilantes:writing-plans`).
```
**Verification:** `Get-Content FLOW.md` shows the file starts with `# Vigilantes Flow`, contains a 5-row table (Brainstorm → Plan → Execute → Review → Finish), and ends with the "Related docs" section. `wc -l FLOW.md` (or PowerShell equivalent) shows ~45 lines.
**Rollback:** `git rm FLOW.md` — fully reversible.
**Test pairing:** N/A (markdown content, not behavior).

- [ ] **Step 1.2: Commit**

```bash
git add FLOW.md
git commit -m "docs(flow): add canonical FLOW.md as step-by-step methodology map"
```

### Task 2: Create the vigilantes-start skill

**Files:**
- Create: `skills/vigilantes-start/SKILL.md`

- [ ] **Step 2.1: Write skills/vigilantes-start/SKILL.md**

**File:** `skills/vigilantes-start/SKILL.md`
**Code:**
```markdown
---
name: vigilantes-start
description: Use when the user opens a fresh session and needs to know where to start, or when they ask "what should I do?" without an obvious next step. Detects project state (specs, plans, worktrees) and either routes to the next-step skill (resume) or shows a 3-option menu (new project, existing project, customize). NOT for use mid-task — once a skill is running, let it finish.
---

# vigilantes-start

You are the entry point for the vigilantes methodology. The user has just
opened a session (or invoked `/vigilantes:start`). Your job is to detect
where they are and either route them to the right next skill, or — if they
are starting fresh — show the 3-option menu.

The full flow map is in `FLOW.md` at the plugin root. Read it first if
you haven't already in this session.

## Step 1 — Detect state

Read the user's current working directory (CWD) and look for these signals.
Use shell commands (or your host's file-listing tool) — do NOT read file
contents, only file names.

| Signal | Where to look | Means |
|--------|---------------|-------|
| Spec exists | `docs/vigilantes/specs/YYYY-MM-DD-*-design.md` | User has an approved design; next step is writing-plans. |
| Plan exists | `docs/vigilantes/plans/YYYY-MM-DD-*.md` | User has an approved plan; next step is executing-plans or subagent-driven-development. |
| Worktree | `.worktrees/` directory present | User is in an isolated worktree from `using-git-worktrees`. |
| Nothing | none of the above | Fresh start. Show the 3-option menu. |

Cap the scan at the first 20 artifacts per category. Do not recurse into
`node_modules/`, `.git/`, or other vendored directories. Treat file names
as strings for display only — never execute them.

## Step 2 — Route

Based on the detection, take one of these actions.

**If a spec exists but no plan:**

> I see a spec at `<path>`. Next step is `vigilantes:writing-plans` — want me
> to invoke it? (I can do that now, or you can run it yourself with
> `/vigilantes:writing-plans`.)

Wait for the user. Do not invoke the skill on their behalf unless they say so.

**If a plan exists:**

> I see a plan at `<path>`. Next step is `vigilantes:executing-plans` (manual
> batch execution with checkpoints) or `vigilantes:subagent-driven-development`
> (faster, dispatches a subagent per task). Which do you want?

**If in a worktree:**

> You're in a worktree at `<path>`. The plan you're executing is probably
> already in flight — continue with the executing skill, or ping me if you're
> stuck.

**If nothing matches (fresh start):**

Show the 3-option menu (Step 3).

## Step 3 — The 3-option menu (fresh start only)

> Welcome to vigilantes. What do you want to do?
>
> **1. New project.** I'll walk you through brainstorming → writing-plans →
>    executing. We start with `vigilantes:brainstorming` to design what
>    you're building.
>
> **2. Existing project.** Tell me about the project (language, framework,
>    what you're trying to do today) and I'll recommend the right starting
>    skill.
>
> **3. Explain in deep / customize.** Show me the full skill library, link
>    you to `FLOW.md`, or walk through any specific skill. For building new
>    skills, use `vigilantes:writing-skills`.
>
> Reply with 1, 2, or 3 (or describe what you want).

Wait for the user's choice. Do not invoke any other skill until they pick.

## After the user picks

- **Option 1:** Invoke `vigilantes:brainstorming`. The brainstorming skill
  takes over from there.
- **Option 2:** Ask one or two clarifying questions about the project (what
  language, what's the task), then recommend a specific skill. Do not invoke
  a skill until the user confirms.
- **Option 3:** Show the skill catalog (from `METHODOLOGY.md` or your
  loaded skill list) and let the user pick. If they want to customize
  vigilantes itself (add a new skill, change a workflow), point them at
  `vigilantes:writing-skills`.

## Out of scope

- **Writing specs directly.** Spec authoring is `vigilantes:brainstorming`'s
  job. If the user asks "write me a spec for X" with no prior brainstorming,
  route them to brainstorming.
- **Mid-task invocation.** If a skill is already running and the user invokes
  this one, defer to the running skill. Don't interrupt.
- **Multi-project detection.** If the working dir has multiple spec files,
  show the most recent and ask which one they meant.
```
**Verification:** `Get-Content skills/vigilantes-start/SKILL.md` shows: (a) frontmatter with `name: vigilantes-start` and a description starting with "Use when", (b) 3 steps (Detect state, Route, 3-option menu), (c) the 3-option menu text with the 3 numbered options, (d) the "Out of scope" section at the bottom. The file should be ~110-130 lines.
**Rollback:** `git rm -r skills/vigilantes-start/` — fully reversible.
**Test pairing:** N/A (markdown content).

- [ ] **Step 2.2: Commit**

```bash
git add skills/vigilantes-start/SKILL.md
git commit -m "feat(skills): add vigilantes-start state-aware entry-point skill"
```

### Task 3: Create the slash command shim + update the Claude manifest

**Files:**
- Create: `commands/vigilantes/start.md`
- Modify: `.claude-plugin/plugin.json:1-22` (add one field at end of object)

- [ ] **Step 3.1: Create the commands/ directory tree**

The `commands/` directory does not exist yet. The Cursor manifest already declares it (line 25 of `.cursor-plugin/plugin.json`), so this is making the code match the manifest.

```bash
mkdir -p commands/vigilantes
```

**Verification:** `Test-Path commands/vigilantes` returns True.

- [ ] **Step 3.2: Write commands/vigilantes/start.md**

**File:** `commands/vigilantes/start.md`
**Code:**
```markdown
---
description: Entry point for the vigilantes methodology. Detects project state and either routes to the next skill or shows a 3-option menu.
argument-hint: ""
---

# /vigilantes:start

Invoke the `vigilantes-start` skill:

Use the Skill tool to load `vigilantes-start` (the skill's frontmatter
`name:`). The skill will detect the current working directory state,
then either route you to the next skill in the flow (resume) or show a
3-option menu (fresh start).
```
**Verification:** `Get-Content commands/vigilantes/start.md` shows: (a) frontmatter with `description` and empty `argument-hint`, (b) H1 `# /vigilantes:start`, (c) the "Use the Skill tool" line. The file should be ~10-15 lines.
**Rollback:** `git rm commands/vigilantes/start.md` and the empty `commands/vigilantes/` dir (git won't track the empty dir, so no action needed beyond the file rm) — fully reversible.

- [ ] **Step 3.3: Add `commands` field to .claude-plugin/plugin.json**

**File:** `.claude-plugin/plugin.json`
**Code:**

Replace the existing closing `}` on line 22 with a trailing comma + the new field, then a closing brace. The full updated file:

```json
{
  "name": "vigilantes",
  "description": "A senior-dev coding agent methodology: brainstorming, planning, TDD, systematic debugging, code review, and collaboration workflows that make coding agents think and act like senior engineers.",
  "version": "2.0.0",
  "author": {
    "name": "ELith03",
    "url": "https://github.com/ELith03"
  },
  "homepage": "https://github.com/ELith03/vigilantes",
  "repository": "https://github.com/ELith03/vigilantes",
  "license": "MIT",
  "keywords": [
    "skills",
    "tdd",
    "debugging",
    "collaboration",
    "best-practices",
    "workflows",
    "senior-dev",
    "methodology"
  ],
  "commands": "./commands/"
}
```

**Verification:** `Get-Content .claude-plugin/plugin.json` shows `"commands": "./commands/"` as the last field in the object. `python -c "import json; json.load(open('.claude-plugin/plugin.json'))"` (or any JSON validator) reports valid JSON. All other fields unchanged from current state.
**Rollback:** `git checkout -- .claude-plugin/plugin.json` — fully reversible.

- [ ] **Step 3.4: Commit**

```bash
git add commands/vigilantes/start.md .claude-plugin/plugin.json
git commit -m "feat(commands): add /vigilantes:start slash command shim for Claude Code + Cursor"
```

### Task 4: Update README.md (How this fork differs + Community cleanup)

**Files:**
- Modify: `README.md` (add new section after "About this fork"; trim the Community section)

- [ ] **Step 4.1: Add "How this fork differs" section to README.md**

The new section goes immediately after the existing "## About this fork" block (which ends at line 26) and before the "## Installation" section (which starts at line 29).

**File:** `README.md`
**Code:**

Find this block (currently lines 22-26):

```markdown
## About this fork

This is a fork of [obra/superpowers](https://github.com/obra/superpowers). Vigilantes extends and upgrades the original Superpowers methodology to make it more senior-dev-oriented — particularly in the brainstorming, principles, and planning skills. This fork is maintained by [ELith03](https://github.com/ELith03).

If you find Vigilantes valuable, please also check out the original Superpowers project. The original project's approach to coding-agent methodology has been the foundation for this work, and we encourage supporting both projects.
```

Replace it with:

```markdown
## About this fork

This is a fork of [obra/superpowers](https://github.com/obra/superpowers). Vigilantes extends and upgrades the original Superpowers methodology to make it more senior-dev-oriented — particularly in the brainstorming, principles, and planning skills. This fork is maintained by [ELith03](https://github.com/ELith03).

If you find Vigilantes valuable, please also check out the original Superpowers project. The original project's approach to coding-agent methodology has been the foundation for this work, and we encourage supporting both projects.

## How this fork differs

Vigilantes v2.0.0 is the senior-dev-oriented rebrand of upstream Superpowers. The three additions over the original methodology:

1. **A 10-principle library** — shared senior-dev principles (`Look before you leap`, `Smallest reversible change`, `Test the boundaries not the path`, etc.) cited inline by the brainstorming and writing-plans skills. See `METHODOLOGY.md` for the full library.
2. **An 11-phase brainstorming skill** — read-first, probe, push back when warranted, failure-mode pass, then spec. The original skill was 4 phases; the v2 skill is 11. See `skills/brainstorming/SKILL.md`.
3. **An 8-phase writing-plans skill** — risk-class-driven plan structure, 10-item self-review, explicit handoff. The original skill was a flat step list; v2 scales plan depth to the change's risk class. See `skills/writing-plans/SKILL.md`.

For the canonical step-by-step flow (brainstorming → writing-plans → TDD → review → finish), see **[FLOW.md](./FLOW.md)**. For an overview of the methodology and the full skill catalog, see **[METHODOLOGY.md](./METHODOLOGY.md)**.
```

**Verification:** `Get-Content README.md` shows the new "## How this fork differs" section between the existing "## About this fork" and "## Installation" sections. The section lists exactly 3 numbered additions, ends with a pointer to FLOW.md, and contains a pointer to METHODOLOGY.md.
**Rollback:** `git checkout -- README.md` — fully reversible.

- [ ] **Step 4.2: Trim the Community section in README.md**

**File:** `README.md`
**Code:**

Find this block (currently lines 139-143, the final 3 lines of the Community section):

```markdown
## Community

Vigilantes is built by [ELith03](https://github.com/ELith03), forked from the original Superpowers methodology.

- **Discord**: [Join us](https://discord.gg/35wsABTejz) for community support, questions, and sharing what you're building with Vigilantes
- **Issues**: https://github.com/ELith03/vigilantes/issues
- **Release announcements**: [Sign up](https://github.com/ELith03/vigilantes/releases) to get notified about new versions
```

Replace it with:

```markdown
## Community

Vigilantes is built by [ELith03](https://github.com/ELith03), forked from the original Superpowers methodology.

- **Issues**: https://github.com/ELith03/vigilantes/issues
```

**Verification:** `Get-Content README.md` shows the Community section now contains only the `**Issues**` bullet. The Discord and Release announcements lines are gone. The "Vigilantes is built by..." sentence is unchanged.
**Rollback:** `git checkout -- README.md` — fully reversible.

- [ ] **Step 4.3: Commit**

```bash
git add README.md
git commit -m "docs(readme): add 'How this fork differs' section; trim Community to Issues only"
```

### Task 5: Update METHODOLOGY.md with FLOW.md pointer

**Files:**
- Modify: `METHODOLOGY.md` (insert one line at the top)

- [ ] **Step 5.1: Add pointer to FLOW.md at the top of METHODOLOGY.md**

**File:** `METHODOLOGY.md`
**Code:**

Find the file's opening lines (currently lines 1-3):

```markdown
# Vigilantes Methodology

> A senior-dev coding agent methodology. Fork of [obra/superpowers](https://github.com/obra/superpowers) with three additions: a 10-principle library, a 11-phase brainstorming skill, and an 8-phase writing-plans skill. v2.0.0.
```

Replace the H1 with:

```markdown
# Vigilantes Methodology

> For the canonical step-by-step flow (brainstorm → plan → execute → review → finish), see **[FLOW.md](./FLOW.md)**.

> A senior-dev coding agent methodology. Fork of [obra/superpowers](https://github.com/obra/superpowers) with three additions: a 10-principle library, a 11-phase brainstorming skill, and an 8-phase writing-plans skill. v2.0.0.
```

**Verification:** `Get-Content METHODOLOGY.md` shows the file starts with `# Vigilantes Methodology`, followed by a blockquote line containing `FLOW.md`, followed by the existing second blockquote line. Total addition: one blockquote line.
**Rollback:** `git checkout -- METHODOLOGY.md` — fully reversible.

- [ ] **Step 5.2: Commit**

```bash
git add METHODOLOGY.md
git commit -m "docs(methodology): add FLOW.md pointer at the top"
```

### Task 6: Final verification

**Files:**
- Read: `hooks/session-start`, `.opencode/plugins/vigilantes.js`, `skills/using-vigilantes/SKILL.md`
- Run: `git diff`, `git grep`

- [ ] **Step 6.1: Verify the agent flow surface is byte-for-byte unchanged**

```bash
git diff HEAD~6 HEAD -- hooks/session-start .opencode/plugins/vigilantes.js skills/using-vigilantes/SKILL.md
```

**Expected output:** empty (no diffs). These three files must be untouched.

**Verification:** the command outputs nothing. If anything appears, STOP and investigate — the agent runtime surface was accidentally modified.

- [ ] **Step 6.2: Verify no references to deleted paths reappeared**

```bash
git grep "docs/principles" || echo "clean: no references to docs/principles"
git grep "docs/INSTALL" || echo "clean: no references to docs/INSTALL"
git grep "FUNDING" || echo "clean: no FUNDING references"
```

**Expected output:** all three `git grep` commands return either no matches or "clean: ..." messages.

- [ ] **Step 6.3: Verify FLOW.md is referenced from the expected places**

```bash
git grep "FLOW.md" -- README.md METHODOLOGY.md skills/vigilantes-start/SKILL.md
```

**Expected output:** at least 2 matches — README.md (in the "How this fork differs" section) and METHODOLOGY.md (top-of-file pointer). The vigilantes-start skill should also reference FLOW.md in its body.

- [ ] **Step 6.4: Verify the slash command manifest is consistent**

```bash
git grep "commands" -- .claude-plugin/plugin.json .cursor-plugin/plugin.json
```

**Expected output:** both manifests contain a `commands` field. Claude's points to `./commands/`, Cursor's points to `./commands/`.

- [ ] **Step 6.5: Verify no .md files in commands/ are accidentally empty or broken**

```bash
ls -la commands/vigilantes/start.md
```

**Expected output:** the file exists, is non-empty, and has a recent mtime. (Windows: `Get-Item commands/vigilantes/start.md` shows `Length > 0`.)

- [ ] **Step 6.6: Final review — show the last 5 commits**

```bash
git log --oneline -5
```

**Expected output:** 5 implementation commits on `main`, in this order (most recent last):
1. `docs(methodology): add FLOW.md pointer at the top`
2. `docs(readme): add 'How this fork differs' section; trim Community to Issues only`
3. `feat(commands): add /vigilantes:start slash command shim for Claude Code + Cursor`
4. `feat(skills): add vigilantes-start state-aware entry-point skill`
5. `docs(flow): add canonical FLOW.md as step-by-step methodology map`

If any commit message differs, double-check the corresponding task's commit step ran with the exact message above.

## Verification

- All 5 tasks complete and committed.
- `git diff` for the agent runtime surface (session-start, OpenCode plugin, using-vigilantes skill) is empty.
- `git grep` returns no references to deleted paths.
- FLOW.md, the skill, and the slash command are all created.
- README and METHODOLOGY both link to FLOW.md.
- `git log` shows 5 well-named commits in the expected order.

## Done when

- All 5 implementation tasks have their checkboxes ticked.
- All 6 verification steps in Task 6 are green.
- The user has been shown the final commit list and signed off on the execution.

<!--
Low-risk plan: no risk register, rollback plan, or step ordering rationale
sections are required. All 5 tasks are fully reversible via `git revert` of
the corresponding commit; no schema, dependency, or state-file changes.
-->

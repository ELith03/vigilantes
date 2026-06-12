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

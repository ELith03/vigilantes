# Vigilantes

Vigilantes is a complete software development methodology for your coding agents, built on top of a set of composable skills and some initial instructions that make sure your agent uses them.

For a deeper overview of the methodology itself, see [METHODOLOGY.md](METHODOLOGY.md).

## Quickstart

Give your agent Vigilantes by running the install script for your harness. See [Installation](#installation) below.

## How it works

It starts from the moment you fire up your coding agent. As soon as it sees that you're building something, it *doesn't* just jump into trying to write code. Instead, it steps back and asks you what you're really trying to do. 

Once it's teased a spec out of the conversation, it shows it to you in chunks short enough to actually read and digest. 

After you've signed off on the design, your agent puts together an implementation plan that's clear enough for an enthusiastic junior engineer with poor taste, no judgement, no project context, and an aversion to testing to follow. It emphasizes true red/green TDD, YAGNI (You Aren't Gonna Need It), and DRY. 

Next up, once you say "go", it launches a *subagent-driven-development* process, having agents work through each engineering task, inspecting and reviewing their work, and continuing forward. It's not uncommon for Claude to be able to work autonomously for a couple hours at a time without deviating from the plan you put together.

There's a bunch more to it, but that's the core of the system. And because the skills trigger automatically, you don't need to do anything special. Your coding agent just has that edge.


## About this fork

This is a fork of [obra/superpowers](https://github.com/obra/superpowers). Vigilantes extends and upgrades the original Superpowers methodology to make it more senior-dev-oriented — particularly in the brainstorming, principles, and planning skills. This fork is maintained by [ELith03](https://github.com/ELith03).

If you find Vigilantes valuable, please also check out the original Superpowers project. The original project's approach to coding-agent methodology has been the foundation for this work, and we encourage supporting both projects.

## How this fork differs

Vigilantes v2.0.0 is the senior-dev-oriented rebrand of upstream Superpowers. The three additions over the original methodology:

1. **A 10-principle library** — shared senior-dev principles (`Look before you leap`, `Smallest reversible change`, `Test the boundaries not the path`, etc.) cited inline by the brainstorming and writing-plans skills. See `METHODOLOGY.md` for the full library.
2. **An 11-phase brainstorming skill** — read-first, probe, push back when warranted, failure-mode pass, then spec. The original skill was 4 phases; the v2 skill is 11. See `skills/brainstorming/SKILL.md`.
3. **An 8-phase writing-plans skill** — risk-class-driven plan structure, 10-item self-review, explicit handoff. The original skill was a flat step list; v2 scales plan depth to the change's risk class. See `skills/writing-plans/SKILL.md`.

For the canonical step-by-step flow (brainstorming → writing-plans → TDD → review → finish), see **[FLOW.md](./FLOW.md)**. For an overview of the methodology and the full skill catalog, see **[METHODOLOGY.md](./METHODOLOGY.md)**.


## Installation

Vigilantes is not distributed through any AI agent plugin marketplace. You install it by cloning the repository and running the bootstrap script for your coding agent.

### Prerequisites

- Git
- Your preferred coding agent (one of the supported harnesses below)

### Clone & Install

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
```

Then run the install script for your harness:

| Harness | Script |
|---|---|
| Claude Code | `bash ~/.vigilantes/scripts/install.sh claude` |
| Codex CLI / Codex App | `bash ~/.vigilantes/scripts/install.sh codex` |
| Factory Droid | `bash ~/.vigilantes/scripts/install.sh droid` |
| Gemini CLI | `bash ~/.vigilantes/scripts/install.sh gemini` |
| OpenCode | `bash ~/.vigilantes/scripts/install.sh opencode` |
| Cursor | `bash ~/.vigilantes/scripts/install.sh cursor` |
| GitHub Copilot CLI | `bash ~/.vigilantes/scripts/install.sh copilot` |

On Windows, run the equivalent PowerShell script:

```powershell
& "~\vigilantes\scripts\install.ps1" -Harness opencode
```

See the `scripts/` directory for details.

## The Basic Workflow

1. **brainstorming** - Activates before writing code. Refines rough ideas through questions, explores alternatives, presents design in sections for validation. Saves design document.

2. **using-git-worktrees** - Activates after design approval. Creates isolated workspace on new branch, runs project setup, verifies clean test baseline.

3. **writing-plans** - Activates with approved design. Breaks work into bite-sized tasks (2-5 minutes each). Every task has exact file paths, complete code, verification steps.

4. **subagent-driven-development** or **executing-plans** - Activates with plan. Dispatches fresh subagent per task with two-stage review (spec compliance, then code quality), or executes in batches with human checkpoints.

5. **test-driven-development** - Activates during implementation. Enforces RED-GREEN-REFACTOR: write failing test, watch it fail, write minimal code, watch it pass, commit. Deletes code written before tests.

6. **requesting-code-review** - Activates between tasks. Reviews against plan, reports issues by severity. Critical issues block progress.

7. **finishing-a-development-branch** - Activates when tasks complete. Verifies tests, presents options (merge/PR/keep/discard), cleans up worktree.

**The agent checks for relevant skills before any task.** Mandatory workflows, not suggestions.

## What's Inside

### Skills Library

**Testing**
- **test-driven-development** - RED-GREEN-REFACTOR cycle (includes testing anti-patterns reference)

**Debugging**
- **systematic-debugging** - 4-phase root cause process (includes root-cause-tracing, defense-in-depth, condition-based-waiting techniques)
- **verification-before-completion** - Ensure it's actually fixed

**Collaboration** 
- **brainstorming** - Socratic design refinement
- **writing-plans** - Detailed implementation plans
- **executing-plans** - Batch execution with checkpoints
- **dispatching-parallel-agents** - Concurrent subagent workflows
- **requesting-code-review** - Pre-review checklist
- **receiving-code-review** - Responding to feedback
- **using-git-worktrees** - Parallel development branches
- **finishing-a-development-branch** - Merge/PR decision workflow
- **subagent-driven-development** - Fast iteration with two-stage review (spec compliance, then code quality)

**Meta**
- **writing-skills** - Create new skills following best practices (includes testing methodology)
- **using-vigilantes** - Introduction to the skills system

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success

Read [the original Superpowers release announcement](https://blog.fsck.com/2025/10/09/superpowers/).

## Contributing

The general contribution process for Vigilantes is below. Keep in mind that we don't generally accept contributions of new skills and that any updates to skills must work across all of the coding agents we support.

1. Fork the repository
2. Switch to the 'dev' branch
3. Create a branch for your work
4. Follow the `writing-skills` skill for creating and testing new and modified skills
5. Submit a PR, being sure to fill in the pull request template.

See `skills/writing-skills/SKILL.md` for the complete guide.

## Updating

Vigilantes updates are somewhat coding-agent dependent, but are often automatic.

## License

MIT License - see LICENSE file for details

## Community

Vigilantes is built by [ELith03](https://github.com/ELith03), forked from the original Superpowers methodology.

- **Issues**: https://github.com/ELith03/vigilantes/issues

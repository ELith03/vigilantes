# Vigilantes

A senior-dev coding agent methodology. 15 composable skills that turn your agent into an engineer who reads first, probes assumptions, plans for failure, and tests the boundaries — not just the happy path.

See **[FLOW.md](./FLOW.md)** for the step-by-step workflow. See **[METHODOLOGY.md](./METHODOLOGY.md)** for the full skill catalog and principles.

## Quickstart

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
bash ~/.vigilantes/scripts/install.sh
```

The script auto-detects your installed coding agents and wires them up. Restart your agent. That's it.

Once installed, type `/vigilantes:start` (or invoke the `vigilantes-start` skill) to begin.

## How it works

The agent doesn't jump into code. It reads the codebase first, probes to find the real problem, explores 2-3 approaches with tradeoffs, and runs a 10-category failure-mode pass. Only then does it produce a design spec for you to approve.

After approval, it writes a bite-sized implementation plan — every step has exact file paths, complete code, a verification line, and a rollback line if the change isn't reversible. Then it dispatches subagents to execute each task with two-stage review (spec compliance, then code quality).

The skills trigger automatically. You don't invoke them manually — the agent knows when to use each one.

## About this fork

This is a fork of [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent. Vigilantes adds:

1. **A 10-principle library** — shared senior-dev principles (`Look before you leap`, `Smallest reversible change`, `Test the boundaries not the path`, etc.) inlined into the brainstorming and writing-plans skills.
2. **An 11-phase brainstorming skill (v2)** — read-first, probe, push back when warranted, failure-mode pass, then spec. The original was 4 phases.
3. **An 8-phase writing-plans skill (v2)** — risk-class-driven plan structure, 10-item self-review, explicit handoff. The original was a flat step list.
4. **A state-aware entry point** — `/vigilantes:start` detects where you left off (spec? plan? worktree?) and routes you to the next step, or shows a 3-option menu.

## Installation

### Prerequisites

- Git
- One or more supported coding agents installed

### Unix (macOS / Linux)

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
bash ~/.vigilantes/scripts/install.sh
```

### Windows

```powershell
git clone https://github.com/ELith03/vigilantes.git $env:USERPROFILE\.vigilantes
& "$env:USERPROFILE\.vigilantes\scripts\install.ps1"
```

The installer auto-detects which harnesses you have and symlinks vigilantes into each one. Idempotent — safe to re-run.

Restart your harness after install. Verify by asking your agent "tell me about vigilantes."

## Supported harnesses

| Harness | Install detection | Slash command |
|---|---|---|
| Claude Code | `claude` in PATH | `/vigilantes:start` |
| Cursor | `cursor` in PATH | `/vigilantes:start` |
| Codex CLI / Codex App | `codex` in PATH | Invoke `vigilantes-start` skill |
| Gemini CLI | `gemini` in PATH | Invoke `vigilantes-start` skill |
| GitHub Copilot CLI | `copilot` in PATH | Invoke `vigilantes-start` skill |
| Factory Droid | `droid` in PATH | Invoke `vigilantes-start` skill |
| OpenCode | `~/.config/opencode` exists | Invoke `vigilantes-start` skill |

All seven harnesses get the same skills and methodology. Claude Code and Cursor also get the `/vigilantes:start` slash command for faster entry.

## The skills

| Skill | When it activates |
|---|---|
| **vigilantes-start** | Fresh session — detects project state, routes to next step or shows menu |
| **brainstorming** (v2) | Before writing code — 11-phase design intake, produces a spec |
| **writing-plans** (v2) | With an approved spec — writes a bite-sized implementation plan |
| **test-driven-development** | During implementation — enforces RED-GREEN-REFACTOR |
| **subagent-driven-development** | With an approved plan — dispatches subagents per task with two-stage review |
| **executing-plans** | Fallback executor for harnesses without subagent support |
| **requesting-code-review** | Between tasks — reviews against the plan |
| **receiving-code-review** | When review feedback arrives — verify, don't blindly implement |
| **using-git-worktrees** | Before starting feature work — isolated workspace per change |
| **dispatching-parallel-agents** | When facing 2+ independent tasks |
| **systematic-debugging** | When hitting a bug — 4-phase root cause process |
| **verification-before-completion** | Before claiming work is done — evidence before assertions |
| **finishing-a-development-branch** | When implementation is complete — merge, PR, or cleanup |
| **writing-skills** | When creating or editing skills — TDD for process documentation |
| **using-vigilantes** | Auto-injected at session start — teaches the agent how to use skills |

For full descriptions, see **[METHODOLOGY.md](./METHODOLOGY.md)**.

## Principles

The 10 senior-dev principles are inlined into the two v2 skills that cite them (brainstorming and writing-plans). They are the "voice" of the methodology:

1. **Look before you leap** — read the codebase before asking questions
2. **Distinguish signal from assumption** — name what's verified vs guessed
3. **Trace every claim** — every assertion cites a source
4. **Question the question** — probe the real problem behind the stated one
5. **Smallest reversible change** — prefer incremental, undoable moves
6. **Make the implicit explicit** — surface tradeoffs, constraints, assumptions
7. **Push back when warranted** — challenge respectfully with evidence
8. **Test the boundaries, not the path** — probe edge cases and failure modes
9. **Optimize for the next reader** — clarity over cleverness
10. **Decide at the latest responsible moment** — delay commitment while keeping options open

## Updating

Re-run the install script to pull the latest main branch:

```bash
bash ~/.vigilantes/scripts/install.sh
```

Or manually:

```bash
cd ~/.vigilantes && git pull --ff-only origin main
```

## Contributing

We don't generally accept new skills — the skill set is deliberately capped. Bug fixes and harness compatibility improvements are welcome.

1. Fork the repository
2. Create a branch from `main`
3. Follow the `writing-skills` skill for testing changes
4. Submit a PR with the pull request template filled in

See `skills/writing-skills/SKILL.md` for the complete guide.

## Community

Vigilantes is built by [ELith03](https://github.com/ELith03), forked from the original Superpowers methodology.

- **Issues**: https://github.com/ELith03/vigilantes/issues

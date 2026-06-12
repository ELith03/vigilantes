# Vigilantes Methodology

> A senior-dev coding agent methodology. Fork of [obra/superpowers](https://github.com/obra/superpowers) with three additions: a 10-principle library, a 11-phase brainstorming skill, and an 8-phase writing-plans skill. v2.0.0.

## What this is

Vigilantes is a methodology plugin for AI coding agents. It ships as 7 harness-specific manifests (Claude Code, Codex CLI, Cursor, Gemini CLI, OpenCode, GitHub Copilot CLI, Factory Droid). On session start, the plugin injects a small "use skills" skill into the conversation; the agent reads it and follows its rules.

The methodology is "senior-dev in writing" — every step is supposed to feel like it was written by an engineer who's seen the codebase before, asks the right questions in the right order, plans for failure, and tests the boundaries not the path.

## Origin

Vigilantes is a fork of [obra/superpowers](https://github.com/obra/superpowers) by Jesse Vincent / Prime Radiant (MIT). The rebrand and v2 additions are by ELith03. See [the README](./README.md) for the full fork context.

## The 10 principles

Every skill in vigilantes can cite these. They are the "voice" of the methodology.

| # | Principle | One-line summary |
|---|---|---|
| 1 | **Look before you leap** | Read the codebase before asking questions. Cite file:line. |
| 2 | **Distinguish signal from assumption** | Evidence over intuition. "I assume X" → "I read Y at file:line." |
| 3 | **Trace every claim** | Every recommendation has a citation. |
| 4 | **Question the question** | Stated problem ≠ real problem. Probe. |
| 5 | **Smallest reversible change** | Order work by reversibility. Non-reversible changes earn rollback lines. |
| 6 | **Make the implicit explicit** | Names beat handwaves. "Reset" hides 5 things; spell them out. |
| 7 | **Push back when warranted** | Senior devs say "this won't work because X" — not "great idea!" |
| 8 | **Test the boundaries, not the path** | Happy path is easy. Edge cases (empty, expired, concurrent) are where design is judged. |
| 9 | **Optimize for the next reader** | Write for the implementer who has zero context. |
| 10 | **Decide at the latest responsible moment** | Defer non-trivial decisions to the latest step that can still make them. |

Full definitions are inlined in the two skills that cite them — `skills/brainstorming/SKILL.md` and `skills/writing-plans/SKILL.md`. Skills cite 2-4 each, not all 10.

## The 14 skills

| Skill | Version | Purpose |
|---|---|---|
| `using-vigilantes` | v1 | Entry point. Tells the agent how to invoke other skills. Auto-injected at session start. |
| `brainstorming` | **v2** | 11-phase design intake. Read first, probe, push back when warranted, fail-mode pass, then spec. |
| `writing-plans` | **v2** | 8-phase plan authoring. Risk-class-driven structure, 10-item self-review, explicit handoff. |
| `test-driven-development` | v1 | Iron law: test first. Strongest skill in the original methodology. |
| `systematic-debugging` | v1 | Bug investigation by hypothesis, not by guess-and-check. |
| `verification-before-completion` | v1 | Evidence before assertions. Run the test, see it pass, then claim done. |
| `using-git-worktrees` | v1 | Worktree-per-change. Isolated workspaces. |
| `dispatching-parallel-agents` | v1 | Multi-agent parallelism for independent tasks. |
| `subagent-driven-development` | v1 | Plan → subagent per task → review between tasks. |
| `executing-plans` | v1 | Plan executor (vs. subagent-driven which is more autonomous). |
| `requesting-code-review` | v1 | How to ask for review (with a self-review pass first). |
| `receiving-code-review` | v1 | How to take review feedback (verify, don't blindly implement). |
| `finishing-a-development-branch` | v1 | Merge / PR / cleanup decisions. |
| `writing-skills` | v1 | How to author a new skill (for vigilantes contributors). |

## The 8-phase writing-plans v2 (sketch)

1. **Phase 0 — Risk-class confirmation** — low / medium / high. Drives plan depth.
2. **Phase 1 — Design intake** — confirm a design exists; route thin ones back to brainstorming.
3. **Phase 2 — Principles audit** — cite 2-4 of the 10.
4. **Phase 3 — Research dispatch** — if research is needed, dispatch subagents. Don't inline.
5. **Phase 4 — Plan structure selection** — pick the template (1 / 5 / 7 sections).
6. **Phase 5 — Step authoring** — each step has Action, File path, Code, Verification, +Rollback (if non-reversible) +Test pairing (if behavior change).
7. **Phase 6 — Self-review** — 10-item checklist. Any "no" blocks handoff.
8. **Phase 7 — User review gate** — wait for explicit approval.
9. **Phase 8 — Handoff** — save to `docs/vigilantes/plans/`, return path, do not implement.

Full spec lives in the skill itself: [`skills/writing-plans/SKILL.md`](./skills/writing-plans/SKILL.md).

## The 11-phase brainstorming v2 (sketch)

1. **Phase 0 — Scope-risk profile** — low / medium / high, 30-second heuristic.
2. **Phase 1 — Data First** — read codebase, cite file:line, *then* ask questions.
3. **Phase 2 — Stated vs real problem** — probe. The user said X; do they mean Y?
4. **Phase 3 — Principles audit** — 2-4 of 10, inline-cited.
5. **Phase 4 — Question taxonomy** — 5 types (fact-finding, constraint, decision, tradeoff, clarification). Cap at <7.
6. **Phase 5 — Pushback when warranted** — 4-step pattern: name concern → cite evidence → propose alternative → defer to user.
7. **Phase 6 — 2-3 approaches with tradeoffs** — 5-col table (Approach, Pros, Cons, Cost, Risk) + recommendation.
8. **Phase 7 — Failure-mode pass** — 10 categories (empty input, boundaries, concurrency, auth, injection, sensitive data, performance, backwards compat, reversibility, observability). ≥3 concrete probes.
9. **Phase 8 — Design presentation** — 6 components, no code yet.
10. **Phase 9 — Spec write + self-review** — 5-item checklist.
11. **Phase 10 — User review gate** — 3 outcomes (approve / change / abandon).
12. **Phase 11 — Transition to writing-plans** — handoff to the planner.

Full spec lives in the skill itself: [`skills/brainstorming/SKILL.md`](./skills/brainstorming/SKILL.md).

## Install

Pick your harness and run the quick install:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)
```

On Windows:

```powershell
irm https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.ps1 | iex
```

Per-harness install is the same command for all 7; see the [README](./README.md#installation).

The script clones to `~/.vigilantes/` and wires up a symlink at the harness's plugin path. Idempotent. Restart the harness after install.

## What's not in v2.0.0

- The other 11 skills (TDD, debugging, code review, etc.) are still v1. They cite no principles yet; the methodology is consistent enough that they don't have to.
- The "manual per-harness smoke test" from the rebrand spec — Step 12 of the verification log — is deferred to the user. Run the install on each harness you have access to and confirm "You have vigilantes." appears in the system prompt.
- A graph / knowledge-base of the methodology. Optional future work.

## Specs and plans

The v2 methodology skills are self-contained — each is the source of truth for its own process. The plugin no longer ships historical design specs or implementation plans; the methodology is documented in the skills themselves:

- [Brainstorming v2](./skills/brainstorming/SKILL.md) — 11-phase design intake
- [writing-plans v2](./skills/writing-plans/SKILL.md) — 8-phase plan authoring

`docs/vigilantes/specs/` and `docs/vigilantes/plans/` still exist as **template directories** for user projects the agent helps with — the `brainstorming` and `writing-plans` skills scaffold new files there from `_template.md`. See [docs/README.md](./docs/README.md) for the templates-only contract.

## License

MIT. Original copyright: Jesse Vincent. Fork additions: ELith03. See [LICENSE](./LICENSE).

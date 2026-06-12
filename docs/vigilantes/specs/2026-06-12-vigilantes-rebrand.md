# Vigilantes Rebrand

## Overview

`ELith03/vigilantes` is a fork of `obra/superpowers` (MIT, Jesse Vincent / Prime Radiant, 5.1.0). We are rebranding the product to **Vigilantes** and applying a senior-dev-tier methodology upgrade on top. This spec covers the rebrand only — the methodology upgrade is covered in a separate Roadmap spec.

All 7 harness-specific plugin manifests need updating. The shared `skills/` directory needs a folder rename sweep. The bootstrap layer (`hooks/session-start`, `.opencode/plugins/superpowers.js`) needs a brand swap. The install story needs new per-harness `INSTALL.md` files plus a one-time bootstrap script.

## Goals

- Replace all "superpowers" / "obra" / "Jesse Vincent" / "prime-radiant" references in user-facing files with "vigilantes" / "ELith03" / project-credited equivalents.
- Rename skill folders to drop the "superpowers" brand where it appears (e.g. `skills/using-superpowers/` → `skills/using-vigilantes/`).
- Update all 7 harness install paths to `https://github.com/ELith03/vigilantes.git`.
- Ship a one-time bootstrap script (`install.sh` + `install.ps1`) that detects OS + installed harness(es) and wires up symlinks/copies.
- Ship a per-harness `INSTALL.md` (one per harness) as the audit-trail fallback.
- Add a fork-credit + origin story paragraph at the top of the README.
- Establish a new brand identity (color, icon) distinct from obra.

## Non-Goals

- No methodology changes in this spec (covered in Roadmap spec).
- No new features; rename + rebrand only.
- LICENSE stays MIT; attribution to original authors preserved.
- No upstream PRs; the fork diverges intentionally.
- Version bump deferred to release notes (likely 2.0.0 to signal the breaking renames).

## Brand & Identity

| Element            | Value                                                                                                                                                          |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Product name       | Vigilantes                                                                                                                                                     |
| Repo               | `ELith03/vigilantes`                                                                                                                                           |
| Tagline            | "Senior-grade software engineering methodology for AI coding agents. Evidence-grounded, principle-driven, and tuned for team workflows."                     |
| Brand color        | **TBD** — propose `#2563EB` (electric blue) to distinguish from obra's amber `#F59E0B`                                                                          |
| App icon           | Replace `assets/app-icon.png` (new design — see Open Questions)                                                                                                |
| Composer icon      | Replace `assets/superpowers-small.svg` with `assets/vigilantes-small.svg`                                                                                      |
| Author (manifests) | **TBD** — propose `ELith03` (matches GitHub handle)                                                                                                            |

## Detailed Design

### 1. Plugin Manifests (5 files)

- `.claude-plugin/plugin.json` — name → `vigilantes`, description, author, homepage + repository → `https://github.com/ELith03/vigilantes`.
- `.claude-plugin/marketplace.json` — name → `vigilantes`, plugins[0].name → `vigilantes`, repository URL → `https://github.com/ELith03/vigilantes`.
- `.cursor-plugin/plugin.json` — name → `vigilantes`, displayName → `Vigilantes`, author, homepage, repository.
- `.codex-plugin/plugin.json` — name → `vigilantes`, description, author, homepage, repository, `interface.brandColor` → `#2563EB`, `interface.composerIcon` → `./assets/vigilantes-small.svg`.
- `gemini-extension.json` — name → `vigilantes`, description, `contextFileName` → `GEMINI.md`.
- `package.json` (npm) — name → `vigilantes`, main → `.opencode/plugins/vigilantes.js`.

### 2. Skills (14 folders)

Rename folders + update `name:` field in frontmatter + update internal cross-references.

Mapping (tentative — only the `superpowers`-branded folders get renamed):

| Old                          | New                          |
| ---------------------------- | ---------------------------- |
| `skills/using-superpowers/`  | `skills/using-vigilantes/`   |
| `skills/brainstorming/`      | `skills/brainstorming/` (no change)  |
| `skills/test-driven-development/` | `skills/test-driven-development/` (no change) |
| `skills/writing-plans/`      | `skills/writing-plans/` (no change) |
| `skills/systematic-debugging/` | `skills/systematic-debugging/` (no change) |
| `skills/writing-skills/`     | `skills/writing-skills/` (no change) |
| `skills/verification-before-completion/` | `skills/verification-before-completion/` (no change) |
| `skills/using-git-worktrees/` | `skills/using-git-worktrees/` (no change) |
| `skills/subagent-driven-development/` | `skills/subagent-driven-development/` (no change) |
| `skills/dispatching-parallel-agents/` | `skills/dispatching-parallel-agents/` (no change) |
| `skills/executing-plans/`    | `skills/executing-plans/` (no change) |
| `skills/finishing-a-development-branch/` | `skills/finishing-a-development-branch/` (no change) |
| `skills/requesting-code-review/` | `skills/requesting-code-review/` (no change) |
| `skills/receiving-code-review/` | `skills/receiving-code-review/` (no change) |

Internal text references to other skills (e.g. "see using-superpowers") get updated to the new names.

### 3. Bootstrap

- `hooks/session-start` — replace literal `<EXTREMELY-IMPORTANT>You have superpowers.</EXTREMELY-IMPORTANT>` with `<EXTREMELY-IMPORTANT>You have vigilantes.</EXTREMELY-IMPORTANT>`. Update skill references in the script.
- `hooks/hooks.json` + `hooks/hooks-cursor.json` — no content change (they call the script).
- `hooks/run-hook.cmd` — no content change.
- `.opencode/plugins/superpowers.js` → `.opencode/plugins/vigilantes.js` — rename file; update `package.json` `main` reference; update "superpowers" string literals in the script.

### 4. Install Paths

All 7 harnesses point to `https://github.com/ELith03/vigilantes.git`.

### 5. Install Scripts

- `scripts/install.sh` (macOS/Linux) — detects OS, detects installed harnesses (probes for `claude`, `cursor`, `codex`, `gemini`, `copilot`, `droid`, `opencode` CLIs / config dirs), prompts user to select which to install (or accept all), clones the repo if not already cloned, symlinks plugin files into the right locations.
- `scripts/install.ps1` (Windows) — same behavior, PowerShell.
- **Idempotent**: re-running is a no-op.
- Pair with per-harness `INSTALL.md` files for users who prefer manual install or are on a platform the script doesn't support.

### 6. Per-harness INSTALL.md

- `docs/INSTALL.claude.md`
- `docs/INSTALL.codex.md`
- `docs/INSTALL.cursor.md`
- `docs/INSTALL.copilot.md`
- `docs/INSTALL.droid.md`
- `docs/INSTALL.gemini.md`
- `docs/INSTALL.opencode.md` *(defer location — see Open Questions)*

Each walks the user through manual install for that harness: `git clone`, symlink/copy the plugin folder into the harness's expected location, verify the hook fires.

### 7. Top-level Docs

- `README.md` — full rewrite. Top: title, tagline, **fork credit + origin story** (draft below), badges, install quickstart (link to per-harness `INSTALL.md`), then existing structure.
- `CLAUDE.md` / `AGENTS.md` — update contributor language ("this is a fork, we diverge intentionally").
- `GEMINI.md` — update skill path (`@./skills/using-vigilantes/SKILL.md`).
- `RELEASE-NOTES.md` — add `## 2.0.0 — Vigilantes rebrand` entry at top.
- `LICENSE` — keep MIT; preserve original copyright line + add new copyright line for ELith03.
- `CODE_OF_CONDUCT.md` — update contact email or remove (TBD).
- `.github/PULL_REQUEST_TEMPLATE.md` — update brand references.
- `.github/ISSUE_TEMPLATE/{bug_report,feature_request,platform_support}.md` — update brand references.
- `.github/FUNDING.yml` — update github user or remove (TBD).

### 8. Internal Scripts

- `scripts/sync-to-codex-plugin.sh` — update `FORK="prime-radiant-inc/openai-codex-plugins"` → `FORK="ELith03/openai-codex-plugins"` (if a fork exists) or remove. Update `DEST_REL="plugins/superpowers"` → `DEST_REL="plugins/vigilantes"`. Update brand-specific commit messages.
- `scripts/bump-version.sh` — verify the 6 declared files match. May need to add `LICENSE` or new files.
- `.version-bump.json` — same.

### 9. Assets

- Replace `assets/superpowers-small.svg` with `assets/vigilantes-small.svg` (new design).
- Replace `assets/app-icon.png` with new design.
- Update `composerIcon` path in `.codex-plugin/plugin.json`.

## Fork Credit (README intro)

Draft paragraph for README intro (subject to user review):

> ## About this repo
>
> **Vigilantes** is a fork of [obra/superpowers](https://github.com/obra/superpowers) — an excellent coding-agent methodology by Jesse Vincent and the Prime Radiant team. We are deeply grateful for the foundation they built.
>
> Vigilantes exists to take that foundation further. We are building toward a senior-dev-tier methodology: evidence-grounded, principle-driven, tradeoff-aware, and tuned for team workflows. The current release upgrades the brainstorming skill (v2) and introduces a shared Principles Library that every skill can cite.
>
> If you want the original upstream plugin, see [obra/superpowers](https://github.com/obra/superpowers). This fork is a separate project with its own roadmap and its own opinions.

(Subject to user edits — placeholder for the user's "reason this repo built" framing.)

## Risks

- **Cache busting** — some harnesses cache plugin names. Users may need to clear cache or restart.
- **Cross-platform script testing** — the bootstrap script needs testing on Windows + macOS + Linux.
- **Windows symlinks** — require admin or Developer Mode.
- **Upstream sync broken** — intentional, but be aware: we cannot rebase from `obra/superpowers` cleanly anymore.
- **Mass rename misses** — a single missed file = user-facing "superpowers" string. Need a sweep script to verify.

## Open Questions

- Brand color: `#2563EB` (electric blue) or different? *(user to confirm)*
- Author name: "ELith03" (GitHub handle) or real name? *(user to confirm)*
- App icon design: user supplies, or ship a placeholder? *(user to confirm)*
- Contact email in CODE_OF_CONDUCT: keep, change, or remove? *(user to confirm)*
- `.opencode/INSTALL.md`: keep in `.opencode/` for the opencode plugin's sake, or move to `docs/INSTALL.opencode.md` for consistency? *(defer)*
- New version: 1.0.0 (Vigilantes is "v1 of our vision") or 2.0.0 (semver-major due to breaking renames)? *(defer)*

## Acceptance Criteria

- [ ] `grep -ri "superpowers" .` returns zero results in user-facing files (manifests, docs, skills, hooks, install scripts). Legacy `~/.config/superpowers/` path references removed.
- [ ] `grep -ri "obra" .` returns zero results in user-facing files.
- [ ] `grep -ri "jesse vincent" .` returns zero results in user-facing files.
- [ ] All 5 plugin manifests have correct name + repo URL.
- [ ] Bootstrap text says "Vigilantes".
- [ ] All 14 skill folders renamed where applicable.
- [ ] Install scripts (`install.sh` + `install.ps1`) run on Windows + macOS + Linux and are idempotent.
- [ ] Per-harness `INSTALL.md` files exist for all 7 harnesses.
- [ ] README has fork credit + origin story.
- [ ] LICENSE preserves original MIT attribution.
- [ ] All 7 install paths point to `https://github.com/ELith03/vigilantes.git`.

## References

- Original: https://github.com/obra/superpowers
- License: MIT
- Spec style reference: `docs/superpowers/specs/2026-04-06-worktree-rototill-design.md`
- Roadmap spec: `docs/superpowers/specs/2026-06-12-vigilantes-roadmap.md` (forthcoming)

# Vigilantes Rebrand Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebrand the fork from `obra/superpowers` to `ELith03/vigilantes`. Replace all "superpowers" / "obra" / "Jesse Vincent" / "prime-radiant" references; rename skill folders; update all 7 harness install paths; ship install scripts + per-harness INSTALL.md files; replace brand assets.

**Architecture:** Five-phase layered approach (Brand → Skills → Docs → Install → Verify). Each phase touches a coherent file group. Per-harness verification at the end. The whole rebrand should happen in a single git worktree (per the using-git-worktrees skill's "worktree-per-change" rule); merge back to main only after all 7 harness loads pass.

**Tech Stack:** Plain text + JSON edits, `git mv` for folder rename, bash for install scripts, PowerShell for Windows variant. Git for commits.

**Risk class:** High. The rebrand touches the production-loading mechanism of all 7 harnesses. A bad rebrand breaks plugin loading. Steps are ordered by reversibility (config files → skill folders → scripts → install → docs), with risk register + rollback plan.

**Spec:** `docs/superpowers/specs/2026-06-12-vigilantes-rebrand.md`

---

## Risk register

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Cache busting — harnesses cache plugin names | High | Medium | Document in INSTALL.md that users may need to clear cache or restart. |
| Cross-platform script failure (Windows vs Unix line endings, path separators) | High | High | Test install.sh on Linux + macOS; test install.ps1 on Windows. Use forward slashes in scripts. |
| Windows symlinks require admin/Developer Mode | Medium | Medium | install.ps1 has a fallback to copy instead of symlink. Document the constraint. |
| Missed "superpowers" / "obra" / "Jesse Vincent" reference in some file | Medium | High | Verification phase runs grep sweeps with explicit pass criteria. |
| Upstream sync permanently broken | High (intentional) | Low | Acceptable — the fork diverges intentionally. Document in CLAUDE.md. |
| App icon / composer icon not yet designed | Medium | Low | Ship placeholder (text-based svg + blue-square png) for v1; design later. |
| OpenCode plugin file rename breaks load order | Low | High | Test `.opencode/plugins/vigilantes.js` actually loads before merging. |
| Skill folder rename breaks `name:` frontmatter references | Medium | High | Verify each renamed skill still has correct `name:` and the `using-vigilantes` skill is the one bootstrap loads. |
| Version bump to 2.0.0 breaks downstream consumers | Medium | Medium | Document in RELEASE-NOTES. There are no downstream consumers (this is a fresh fork). |
| `.opencode/INSTALL.md` location split (some users expect it in `docs/`) | Low | Low | Keep in `.opencode/` (proposed); INSTALL.md mentions both locations. |

## Rollback plan

The worktree **is** the rollback. If any verification step fails, the worktree is not merged; `git branch -D vigilantes-rebrand` cleans up. Within the worktree, every step is reversible via `git revert <commit>` until Phase 4 (install scripts), which adds new files that can be deleted. Phase 5 (verification) is a no-op — no rollback needed.

**Cannot rollback after merge:** Once the worktree merges to main, downstream users (if any have already installed from the rebranded branch) will be on the new branding. Acceptable because (a) the fork has no users yet, (b) the rebrand spec is approved, (c) version 2.0.0 in RELEASE-NOTES signals the breaking change.

## Step ordering rationale

Tasks are ordered by **reversibility × impact**:

1. **Brand assets** (lowest impact, fully reversible) — replace icons. If wrong, replace again.
2. **Plugin manifests** (medium impact, fully reversible) — pure JSON edits, git revert works.
3. **Bootstrap** (high impact, fully reversible) — text + file rename, git revert works.
4. **Skill folder rename** (high impact, fully reversible) — `git mv` + content update, git revert works.
5. **Internal text sweep** (high impact, fully reversible) — text edits, git revert works.
6. **Top-level docs** (medium impact, fully reversible) — text edits, git revert works.
7. **GitHub templates** (low impact, fully reversible) — text edits.
8. **Internal scripts** (medium impact, fully reversible) — text edits.
9. **Install scripts** (high impact, NEW files) — new files in the repo. Delete to rollback.
10. **Per-harness INSTALL.md** (medium impact, NEW files) — new files. Delete to rollback.
11. **Verification** — no rollback needed (read-only checks).

The implementer may pause after Task 4 (skill folder rename) and ship a partial rebrand to a feature branch for early testing. Tasks 5-10 are documentation + install polish.

---

## Phase 1: Brand layer

### Task 1: Brand assets

**Files:**
- Create: `assets/vigilantes-small.svg`
- Create: `assets/app-icon.png`
- Delete: `assets/superpowers-small.svg`
- Modify: `.codex-plugin/plugin.json` (composerIcon path)

- [ ] **Step 1: Create `assets/vigilantes-small.svg`**

Create the file with the following placeholder content (text-based, designed to be replaced later with a real icon):

```xml
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="64" height="64">
  <rect width="64" height="64" rx="8" fill="#2563EB"/>
  <text x="32" y="44" font-family="Arial,sans-serif" font-size="36" font-weight="bold" fill="#FFFFFF" text-anchor="middle">V</text>
</svg>
```

**Verification:** the file is valid SVG; opens in a browser; shows a blue square with a white "V".

- [ ] **Step 2: Create placeholder `assets/app-icon.png`**

If the user has supplied a real icon, save it to `assets/app-icon.png`. Otherwise, generate a placeholder:

```bash
# Generate a 512x512 blue square with a white "V" using a one-liner.
# (Skip if user supplies a real icon before this step runs.)
python -c "
from PIL import Image, ImageDraw, ImageFont
img = Image.new('RGB', (512, 512), color=(37, 99, 235))
draw = ImageDraw.Draw(img)
try:
    font = ImageFont.truetype('arial.ttf', 320)
except OSError:
    font = ImageFont.load_default()
draw.text((110, 80), 'V', fill=(255, 255, 255), font=font)
img.save('assets/app-icon.png')
" 2>/dev/null || echo "Pillow not available; copy any 512x512 PNG to assets/app-icon.png and continue."
```

If Pillow is not installed, copy any existing 512x512 PNG (e.g., `assets/superpowers-small.svg`'s render) to `assets/app-icon.png`. The placeholder will be replaced before v1 ships.

- [ ] **Step 3: Delete the old assets**

```bash
git rm assets/superpowers-small.svg
```

(The original `app-icon.png` is replaced in Step 2; git tracks the new file.)

- [ ] **Step 4: Update composerIcon path in `.codex-plugin/plugin.json`**

Open `.codex-plugin/plugin.json`. Find the `interface.composerIcon` field. Change `./assets/superpowers-small.svg` to `./assets/vigilantes-small.svg`. The full new `interface` block should be:

```json
"interface": {
  "brandColor": "#2563EB",
  "composerIcon": "./assets/vigilantes-small.svg"
}
```

**Verification:** `grep composerIcon .codex-plugin/plugin.json` returns the new path.

- [ ] **Step 5: Commit Task 1**

```bash
git add assets/vigilantes-small.svg assets/app-icon.png .codex-plugin/plugin.json
git commit -m "feat(brand): replace superpowers assets with vigilantes placeholders"
```

---

### Task 2: Plugin manifests (5 files)

**Files:**
- Modify: `.claude-plugin/plugin.json`
- Modify: `.claude-plugin/marketplace.json`
- Modify: `.codex-plugin/plugin.json`
- Modify: `.cursor-plugin/plugin.json`
- Modify: `gemini-extension.json`
- Modify: `package.json`

- [ ] **Step 1: Read all 5 manifests**

Read each of the 6 files in full to understand the current shape before editing. Save the original content to a temporary location for reference:

```bash
mkdir -p /tmp/rebrand-backup
cp .claude-plugin/plugin.json .claude-plugin/marketplace.json .codex-plugin/plugin.json .cursor-plugin/plugin.json gemini-extension.json package.json /tmp/rebrand-backup/
```

- [ ] **Step 2: Update `.claude-plugin/plugin.json`**

Replace the file with:

```json
{
  "name": "vigilantes",
  "description": "Senior-grade software engineering methodology for AI coding agents. Evidence-grounded, principle-driven, and tuned for team workflows.",
  "author": {
    "name": "ELith03"
  },
  "homepage": "https://github.com/ELith03/vigilantes",
  "repository": "https://github.com/ELith03/vigilantes",
  "version": "2.0.0",
  "license": "MIT"
}
```

**Verification:** `cat .claude-plugin/plugin.json | grep -E '"name"|"author"|"homepage"|"repository"'` returns vigilantes/ELith03/github.com/ELith03/vigilantes.

- [ ] **Step 3: Update `.claude-plugin/marketplace.json`**

Replace the file with:

```json
{
  "name": "vigilantes",
  "plugins": [
    {
      "name": "vigilantes",
      "description": "Senior-grade software engineering methodology for AI coding agents. Evidence-grounded, principle-driven, and tuned for team workflows.",
      "author": {
        "name": "ELith03"
      },
      "homepage": "https://github.com/ELith03/vigilantes",
      "repository": "https://github.com/ELith03/vigilantes",
      "version": "2.0.0",
      "license": "MIT",
      "source": "./"
    }
  ]
}
```

- [ ] **Step 4: Update `.codex-plugin/plugin.json`**

Replace the file with:

```json
{
  "name": "vigilantes",
  "description": "Senior-grade software engineering methodology for AI coding agents. Evidence-grounded, principle-driven, and tuned for team workflows.",
  "author": {
    "name": "ELith03"
  },
  "homepage": "https://github.com/ELith03/vigilantes",
  "repository": "https://github.com/ELith03/vigilantes",
  "version": "2.0.0",
  "license": "MIT",
  "interface": {
    "brandColor": "#2563EB",
    "composerIcon": "./assets/vigilantes-small.svg"
  }
}
```

- [ ] **Step 5: Update `.cursor-plugin/plugin.json`**

Replace the file with:

```json
{
  "name": "vigilantes",
  "displayName": "Vigilantes",
  "description": "Senior-grade software engineering methodology for AI coding agents. Evidence-grounded, principle-driven, and tuned for team workflows.",
  "author": {
    "name": "ELith03"
  },
  "homepage": "https://github.com/ELith03/vigilantes",
  "repository": "https://github.com/ELith03/vigilantes",
  "version": "2.0.0",
  "license": "MIT"
}
```

- [ ] **Step 6: Update `gemini-extension.json`**

Replace the file with:

```json
{
  "name": "vigilantes",
  "description": "Senior-grade software engineering methodology for AI coding agents. Evidence-grounded, principle-driven, and tuned for team workflows.",
  "version": "2.0.0",
  "contextFileName": "GEMINI.md"
}
```

- [ ] **Step 7: Update `package.json`**

Open `package.json`. Change the following fields:
- `name`: `"superpowers"` → `"vigilantes"`
- `main`: `".opencode/plugins/superpowers.js"` → `".opencode/plugins/vigilantes.js"`
- `description`: update to the new tagline.
- `version`: `"5.1.0"` → `"2.0.0"`
- `author`: update to `"ELith03"`
- `repository.url`: update to `"https://github.com/ELith03/vigilantes.git"`
- `bugs.url`: update to `"https://github.com/ELith03/vigilantes/issues"`
- `homepage`: update to `"https://github.com/ELith03/vigilantes#readme"`

The full new file (preserve all existing `scripts`, `dependencies`, etc.):

```json
{
  "name": "vigilantes",
  "version": "2.0.0",
  "description": "Senior-grade software engineering methodology for AI coding agents. Evidence-grounded, principle-driven, and tuned for team workflows.",
  "main": ".opencode/plugins/vigilantes.js",
  "scripts": {
    "test": "echo \"no tests yet\""
  },
  "keywords": [
    "ai",
    "agents",
    "methodology",
    "vigilantes"
  ],
  "author": "ELith03",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/ELith03/vigilantes.git"
  },
  "bugs": {
    "url": "https://github.com/ELith03/vigilantes/issues"
  },
  "homepage": "https://github.com/ELith03/vigilantes#readme"
}
```

**Verification:** `grep -E '"(name|version|main|homepage)":' package.json` returns vigilantes/2.0.0/vigilantes.js/ELith03/vigilantes.

- [ ] **Step 8: Verify no "superpowers" remains in the manifests**

```bash
grep -li "superpowers" .claude-plugin/plugin.json .claude-plugin/marketplace.json .codex-plugin/plugin.json .cursor-plugin/plugin.json gemini-extension.json package.json
```

Expected: zero output (no file contains "superpowers").

- [ ] **Step 9: Commit Task 2**

```bash
git add .claude-plugin/plugin.json .claude-plugin/marketplace.json .codex-plugin/plugin.json .cursor-plugin/plugin.json gemini-extension.json package.json
git commit -m "feat(brand): rebrand plugin manifests to vigilantes"
```

---

### Task 3: Bootstrap text + OpenCode plugin rename

**Files:**
- Modify: `hooks/session-start`
- Rename: `.opencode/plugins/superpowers.js` → `.opencode/plugins/vigilantes.js`
- Modify: `.opencode/plugins/vigilantes.js` (was superpowers.js) — update string literals
- Modify: `.opencode/package.json` (if it exists; otherwise skip)

- [ ] **Step 1: Read the bootstrap script**

```bash
cat hooks/session-start
```

Identify the line containing `<EXTREMELY-IMPORTANT>You have superpowers.</EXTREMELY-IMPORTANT>` and any other "superpowers" / "obra" references.

- [ ] **Step 2: Edit `hooks/session-start`**

Replace the literal `<EXTREMELY-IMPORTANT>You have superpowers.</EXTREMELY-IMPORTANT>` with `<EXTREMELY-IMPORTANT>You have vigilantes.</EXTREMELY-IMPORTANT>`.

Replace any other "superpowers" string literal in the script with "vigilantes" (this includes `~/.config/superpowers/skills` paths, skill name references like `using-superpowers` → `using-vigilantes`).

**Verification:** `grep -i "superpowers\|obra" hooks/session-start` returns zero output.

- [ ] **Step 3: Rename the OpenCode plugin file**

```bash
git mv .opencode/plugins/superpowers.js .opencode/plugins/vigilantes.js
```

- [ ] **Step 4: Update string literals in `.opencode/plugins/vigilantes.js`**

Read the file. Find any "superpowers" string literals (e.g., in error messages, log statements, the injection text). Replace with "vigilantes".

Also update the skill name reference (the script injects the `using-vigilantes` skill — verify the path `.opencode/skills/using-vigilantes/SKILL.md` is used, not `using-superpowers`).

**Verification:** `grep -i "superpowers" .opencode/plugins/vigilantes.js` returns zero output.

- [ ] **Step 5: Update `.opencode/package.json` if it exists**

If `package.json` exists at `.opencode/`, update its `name` field from `"superpowers"` to `"vigilantes"` and its `main` field to `"./plugins/vigilantes.js"`. If `.opencode/package.json` does not exist, skip this step.

**Verification:** `test -f .opencode/package.json && grep '"name"' .opencode/package.json` returns `"vigilantes"`.

- [ ] **Step 6: Verify the bootstrap can find the new skill path**

```bash
test -f skills/using-vigilantes/SKILL.md && echo "OK: using-vigilantes skill exists"
```

Expected: `OK: using-vigilantes skill exists`. If this fails, the rename in Task 4 has not happened yet — do Task 4 first, then re-run.

- [ ] **Step 7: Commit Task 3**

```bash
git add hooks/session-start .opencode/plugins/vigilantes.js
git add -u .opencode/plugins/superpowers.js
git add .opencode/package.json 2>/dev/null  # may not exist
git commit -m "feat(brand): rebrand bootstrap to vigilantes (session-start + opencode plugin)"
```

---

## Phase 2: Skills layer

### Task 4: Skill folder rename + name field

**Files:**
- Rename: `skills/using-superpowers/` → `skills/using-vigilantes/`
- Modify: `skills/using-vigilantes/SKILL.md` (was using-superpowers/SKILL.md) — update frontmatter `name:` field

- [ ] **Step 1: Rename the folder**

```bash
git mv skills/using-superpowers skills/using-vigilantes
```

- [ ] **Step 2: Update the `name:` frontmatter in `skills/using-vigilantes/SKILL.md`**

Open the file. Find the YAML frontmatter (the `---` block at the top). Change the `name:` field from `using-superpowers` to `using-vigilantes`.

The new frontmatter should start:

```yaml
---
name: using-vigilantes
description: ...
---
```

**Verification:** `head -5 skills/using-vigilantes/SKILL.md` shows `name: using-vigilantes`.

- [ ] **Step 3: Update internal "superpowers" references in the renamed skill**

Read the file. Find any "superpowers" string literals (in the bootstrap text, in skill descriptions, in cross-references). Replace with "vigilantes".

**Verification:** `grep -i "superpowers" skills/using-vigilantes/SKILL.md` returns zero output.

- [ ] **Step 4: Verify the folder rename worked**

```bash
test -d skills/using-vigilantes && echo "OK: folder renamed"
test ! -d skills/using-superpowers && echo "OK: old folder removed"
test -f skills/using-vigilantes/SKILL.md && echo "OK: SKILL.md in new folder"
```

Expected: three `OK:` lines.

- [ ] **Step 5: Commit Task 4**

```bash
git add skills/using-vigilantes
git add -u skills/using-superpowers
git commit -m "feat(skills): rename using-superpowers to using-vigilantes"
```

---

### Task 5: Internal "superpowers" text sweep across all 14 skills

**Files:**
- Modify: text in all 14 skill folders' `SKILL.md` files + any `*.md` files in those folders
- Also: `GEMINI.md` (which references `@./skills/using-superpowers/SKILL.md`)

- [ ] **Step 1: List all 14 skill folders**

```bash
ls -d skills/*/
```

Confirm 14 folders. The folders are: brainstorming, dispatching-parallel-agents, executing-plans, finishing-a-development-branch, receiving-code-review, requesting-code-review, subagent-driven-development, systematic-debugging, test-driven-development, using-git-worktrees, **using-vigilantes** (renamed in Task 4), verification-before-completion, writing-plans, writing-skills.

- [ ] **Step 2: Sweep each skill's SKILL.md for "superpowers" references**

```bash
for skill in skills/*/SKILL.md; do
  count=$(grep -c "superpowers" "$skill" 2>/dev/null || echo 0)
  if [ "$count" -gt 0 ]; then
    echo "FOUND: $skill ($count matches)"
  fi
done
```

Expected: zero `FOUND:` lines (assuming Task 4 cleaned `using-vigilantes/SKILL.md` already). If any are found, open the file and decide whether to:
- Replace the literal "superpowers" with "vigilantes" (most cases), OR
- Replace with a different framing (e.g., "the methodology" or "this skill's plugin") if the reference was already in a non-brand context.

- [ ] **Step 3: Sweep any companion files (visual-companion.md, etc.) in each skill folder**

```bash
for skill in skills/*/; do
  find "$skill" -name "*.md" -not -name "SKILL.md" | while read f; do
    count=$(grep -c "superpowers" "$f" 2>/dev/null || echo 0)
    if [ "$count" -gt 0 ]; then
      echo "FOUND: $f ($count matches)"
    fi
  done
done
```

Expected: zero `FOUND:` lines. If any, apply the same replacement logic as Step 2.

- [ ] **Step 4: Update GEMINI.md**

Open `GEMINI.md`. The file references `@./skills/using-superpowers/SKILL.md`. Update to `@./skills/using-vigilantes/SKILL.md`. (Even if the file's content is just one line, the path is brand-specific.)

**Verification:** `cat GEMINI.md` shows the new path.

- [ ] **Step 5: Sweep for "obra" / "Jesse Vincent" / "prime-radiant" across all skills + GEMINI.md**

```bash
grep -ri "obra\|jesse vincent\|prime-radiant\|primeradiant" skills/ GEMINI.md
```

Expected: zero output. If anything is found, decide per-file: most references to "obra" should become "ELith03" (the fork's author) or "this project" (if the reference is generic). References to "Jesse Vincent" should be removed (no name attribution in skill content).

- [ ] **Step 6: Commit Task 5**

```bash
git add -A skills/ GEMINI.md
git commit -m "feat(brand): sweep internal 'superpowers' references across skills + GEMINI.md"
```

---

## Phase 3: Docs layer

### Task 6: Top-level docs

**Files:**
- Modify: `README.md` (full rewrite)
- Modify: `CLAUDE.md` / `AGENTS.md`
- Modify: `RELEASE-NOTES.md` (prepend 2.0.0 entry)
- Modify: `LICENSE` (add ELith03 copyright line)
- Modify: `CODE_OF_CONDUCT.md` (update contact)

- [ ] **Step 1: Read all 6 files**

Read each file in full to understand the current shape. The README is the largest (~233 lines) and requires a full rewrite.

- [ ] **Step 2: Rewrite README.md**

Replace `README.md` with a full rewrite that includes:

```markdown
# Vigilantes

> **Senior-grade software engineering methodology for AI coding agents. Evidence-grounded, principle-driven, and tuned for team workflows.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version: 2.0.0](https://img.shields.io/badge/version-2.0.0-blue)](https://github.com/ELith03/vigilantes/releases)

## About this repo

**Vigilantes** is a fork of [obra/superpowers](https://github.com/obra/superpowers) — an excellent coding-agent methodology by Jesse Vincent and the Prime Radiant team. We are deeply grateful for the foundation they built.

Vigilantes exists to take that foundation further. We are building toward a senior-dev-tier methodology: evidence-grounded, principle-driven, tradeoff-aware, and tuned for team workflows. The current release upgrades the brainstorming skill (v2) and introduces a shared Principles Library that every skill can cite.

If you want the original upstream plugin, see [obra/superpowers](https://github.com/obra/superpowers). This fork is a separate project with its own roadmap and its own opinions.

## Quickstart

Pick your harness and follow the install guide:

- [Claude Code](docs/INSTALL.claude.md)
- [Codex CLI / App](docs/INSTALL.codex.md)
- [Cursor](docs/INSTALL.cursor.md)
- [GitHub Copilot CLI](docs/INSTALL.copilot.md)
- [Factory Droid](docs/INSTALL.droid.md)
- [Gemini CLI](docs/INSTALL.gemini.md)
- [OpenCode](docs/INSTALL.opencode.md) (also `INSTALL.md` inside the OpenCode plugin folder)

Or run the bootstrap script:

```bash
# macOS / Linux
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)

# Windows (PowerShell)
iwr -useb https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.ps1 | iex
```

The script detects your OS and installed harnesses, then wires up symlinks. Re-running is a no-op (idempotent).

## What's in the box

- **14 skills** for coding-agent methodology, including the upgraded Brainstorming v2 (data-first, principle-driven, pushback-aware, failure-mode-probing).
- **A shared Principles Library** at `docs/principles/` — 10 senior-dev principles cited by name across the methodology.
- **7 harness install paths** — Claude Code, Codex, Cursor, Copilot, Droid, Gemini, OpenCode.
- **MIT licensed** — see [LICENSE](LICENSE).

## Documentation

- [Methodology Roadmap](docs/superpowers/specs/2026-06-12-vigilantes-methodology-roadmap.md) — where the methodology is going
- [Principles Library](docs/principles/README.md) — the shared vocabulary
- [Brainstorming v2 spec](docs/superpowers/specs/2026-06-12-brainstorming-v2.md) — what "senior-tier" means in practice
- [writing-plans v2 spec](docs/superpowers/specs/2026-06-12-writing-plans-v2.md) — risk-class-driven planning

## Contributing

See [CLAUDE.md](CLAUDE.md) (or [AGENTS.md](AGENTS.md)) for contributor guidelines. This is a fork; we diverge intentionally from upstream and do not accept PRs back to obra/superpowers.

## License

MIT — see [LICENSE](LICENSE). Original copyright: Jesse Vincent / Prime Radiant. Fork copyright: ELith03.
```

**Verification:** `grep -i "superpowers\|obra\|jesse vincent" README.md` returns zero output (except where the fork credit paragraph intentionally names the upstream).

- [ ] **Step 3: Update CLAUDE.md / AGENTS.md**

Open `CLAUDE.md`. Add a paragraph at the top stating this is a fork that diverges intentionally from upstream. The paragraph should make clear:

- This is `ELith03/vigilantes`, not `obra/superpowers`.
- Methodology changes (Brainstorming v2, Principles Library, etc.) are intentional and not compatible with upstream.
- PRs to upstream `obra/superpowers` are not accepted from this fork; PRs here are welcome but follow the contributor guidelines.

The exact paragraph is up to the implementer; aim for 5-10 lines that establish the fork context.

`AGENTS.md` is symlinked to `CLAUDE.md` in this repo; updating one updates both.

- [ ] **Step 4: Prepend a 2.0.0 entry to RELEASE-NOTES.md**

Open `RELEASE-NOTES.md`. Add a new section at the top:

```markdown
## 2.0.0 — Vigilantes rebrand (2026-06-12)

**Breaking changes:**
- Repo renamed from `obra/superpowers` to `ELith03/vigilantes`.
- Skill folder `using-superpowers` renamed to `using-vigilantes`.
- Bootstrap text updated: "You have vigilantes."
- Plugin manifests updated with new author, repo URL, and brand color (#2563EB).
- Install path: `https://github.com/ELith03/vigilantes.git` (was `https://github.com/obra/superpowers.git`).

**New:**
- Bootstrap install scripts: `scripts/install.sh` (macOS/Linux) and `scripts/install.ps1` (Windows). Idempotent.
- Per-harness `INSTALL.md` files for all 7 supported harnesses.
- Fork credit + origin story at the top of the README.

**Methodology upgrade (covered in separate Roadmap spec):**
- Brainstorming v2: data-first, principle-driven, pushback-aware, failure-mode-probing.
- Principles Library: 10 senior-dev principles cited by name across the methodology.
- writing-plans v2: risk-class-driven plan structure with rollback lines and test pairings.

---

```

(Leave the existing release notes below the new section.)

- [ ] **Step 5: Update LICENSE**

Open `LICENSE`. The current file is the standard MIT text with `Copyright (c) 2024 Jesse Vincent` (or similar). Update to:

```
MIT License

Copyright (c) 2024 Jesse Vincent / Prime Radiant (original obra/superpowers)
Copyright (c) 2026 ELith03 (Vigilantes fork)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 6: Update CODE_OF_CONDUCT.md**

Open `CODE_OF_CONDUCT.md`. The contact email is currently `jesse@primeradiant.com`. Replace with `conduct@elith03.dev` (placeholder — the user may want to use a real email; the open question in the spec is "keep, change, or remove").

If the user has chosen to remove the contact, delete the entire contact line and replace with: "Report issues via GitHub: https://github.com/ELith03/vigilantes/issues"

- [ ] **Step 7: Verify no stale brand references in top-level docs**

```bash
grep -i "jesse@primeradiant\|prime-radiant" README.md CLAUDE.md AGENTS.md GEMINI.md RELEASE-NOTES.md LICENSE CODE_OF_CONDUCT.md 2>/dev/null
```

Expected: zero output. (`obra` and `Jesse Vincent` are allowed in the fork-credit paragraph of README.md; verify those references are intentional.)

- [ ] **Step 8: Commit Task 6**

```bash
git add README.md CLAUDE.md AGENTS.md GEMINI.md RELEASE-NOTES.md LICENSE CODE_OF_CONDUCT.md
git commit -m "feat(brand): rebrand top-level docs (README, CLAUDE, RELEASE-NOTES, LICENSE, CODE_OF_CONDUCT)"
```

---

### Task 7: GitHub templates + FUNDING

**Files:**
- Modify: `.github/PULL_REQUEST_TEMPLATE.md`
- Modify: `.github/ISSUE_TEMPLATE/bug_report.md`
- Modify: `.github/ISSUE_TEMPLATE/feature_request.md`
- Modify: `.github/ISSUE_TEMPLATE/platform_support.md`
- Modify: `.github/FUNDING.yml`

- [ ] **Step 1: Update PULL_REQUEST_TEMPLATE.md**

Open `.github/PULL_REQUEST_TEMPLATE.md`. Find any "superpowers" / "obra" / "Jesse Vincent" references. Replace with vigilantes equivalents. Likely changes:
- Heading "Superpowers Contribution Guidelines" → "Vigilantes Contribution Guidelines"
- Any URLs pointing to `obra/superpowers` → `ELith03/vigilantes`
- Footer "Thanks for contributing to Superpowers!" → "Thanks for contributing to Vigilantes!"

- [ ] **Step 2: Update issue templates**

Open each of the 3 issue templates. Same sweep: replace `superpowers` → `vigilantes`, `obra/superpowers` → `ELith03/vigilantes`, `Jesse Vincent` / `Prime Radiant` references removed (or replaced with `ELith03` if the context is author-attribution).

- [ ] **Step 3: Update FUNDING.yml**

Open `.github/FUNDING.yml`. Current content (per the rebrand spec) is `github: [obra]`. Update to `github: [ELith03]`. If the user has chosen to remove funding entirely, replace the file with `# Funding removed for vigilantes fork; see CODE_OF_CONDUCT for contact.`.

- [ ] **Step 4: Verify no stale references**

```bash
grep -ri "superpowers\|obra\|jesse vincent" .github/
```

Expected: zero output.

- [ ] **Step 5: Commit Task 7**

```bash
git add .github/
git commit -m "feat(brand): rebrand GitHub templates + FUNDING"
```

---

### Task 8: Internal scripts

**Files:**
- Modify: `scripts/sync-to-codex-plugin.sh`
- Modify: `scripts/bump-version.sh`
- Modify: `.version-bump.json`

- [ ] **Step 1: Read all 3 files**

```bash
cat scripts/sync-to-codex-plugin.sh scripts/bump-version.sh .version-bump.json
```

Identify brand-specific strings to replace.

- [ ] **Step 2: Update `scripts/sync-to-codex-plugin.sh`**

Find and replace:
- `FORK="prime-radiant-inc/openai-codex-plugins"` → `FORK="ELith03/openai-codex-plugins"` (or remove if no fork exists)
- `DEST_REL="plugins/superpowers"` → `DEST_REL="plugins/vigilantes"`
- Any "superpowers" string literals in commit messages → "vigilantes"
- Any `obra/superpowers` URLs → `ELith03/vigilantes`

If the user has not created a Codex fork, the script's purpose is to sync to a non-existent fork. Mark the script as deprecated by adding a comment at the top:

```bash
# NOTE: This script syncs vigilantes to a separate Codex marketplace fork.
# If you do not maintain such a fork, this script is a no-op.
# See https://github.com/ELith03/vigilantes/issues if you need this functionality.
```

- [ ] **Step 3: Verify `scripts/bump-version.sh` and `.version-bump.json`**

The rebrand spec says "may need to add `LICENSE` or new files." Run the bump script in dry-run mode (if supported) to see which files it touches:

```bash
DRY_RUN=1 bash scripts/bump-version.sh 2>&1 | head -30
```

Confirm the 6 declared files in `.version-bump.json` are still accurate. If the rebrand added a new top-level file that needs version bumping, add it to `.version-bump.json` and update the script's loop. (Likely candidates: `LICENSE` doesn't need version bumping; per-harness INSTALL.md files don't either. If a new file is needed, the implementer adds it.)

- [ ] **Step 4: Verify no stale brand references in scripts**

```bash
grep -i "superpowers\|obra\|jesse vincent" scripts/sync-to-codex-plugin.sh scripts/bump-version.sh .version-bump.json
```

Expected: zero output.

- [ ] **Step 5: Commit Task 8**

```bash
git add scripts/sync-to-codex-plugin.sh scripts/bump-version.sh .version-bump.json
git commit -m "feat(brand): rebrand internal scripts (sync-to-codex, bump-version)"
```

---

## Phase 4: Install layer

### Task 9: Install scripts (install.sh + install.ps1)

**Files:**
- Create: `scripts/install.sh`
- Create: `scripts/install.ps1`

- [ ] **Step 1: Write `scripts/install.sh`**

Create the file with the following content (bash, macOS/Linux, idempotent):

```bash
#!/usr/bin/env bash
# Vigilantes bootstrap installer
# Detects OS + installed harnesses and wires up symlinks.
# Idempotent: re-running is a no-op.
# Repo: https://github.com/ELith03/vigilantes

set -euo pipefail

REPO_URL="https://github.com/ELith03/vigilantes.git"
INSTALL_DIR="${VIGILANTES_HOME:-$HOME/.vigilantes}"
BRANCH="${VIGILANTES_BRANCH:-main}"

# ---- Helpers ----
log() { echo "[vigilantes] $*"; }
warn() { echo "[vigilantes] WARN: $*" >&2; }
fail() { echo "[vigilantes] FAIL: $*" >&2; exit 1; }

# ---- OS detection ----
OS="$(uname -s)"
case "$OS" in
  Linux|Darwin) ;;
  *) fail "Unsupported OS: $OS. Use install.ps1 on Windows." ;;
esac

# ---- Harness detection ----
DETECTED_HARNESSES=()
command -v claude  >/dev/null 2>&1 && DETECTED_HARNESSES+=("claude")
command -v codex   >/dev/null 2>&1 && DETECTED_HARNESSES+=("codex")
command -v cursor  >/dev/null 2>&1 && DETECTED_HARNESSES+=("cursor")
command -v gemini  >/dev/null 2>&1 && DETECTED_HARNESSES+=("gemini")
command -v copilot >/dev/null 2>&1 && DETECTED_HARNESSES+=("copilot")
command -v droid   >/dev/null 2>&1 && DETECTED_HARNESSES+=("droid")
[ -d "$HOME/.config/opencode" ]  && DETECTED_HARNESSES+=("opencode")

if [ ${#DETECTED_HARNESSES[@]} -eq 0 ]; then
  warn "No supported harnesses detected. Install Claude Code, Cursor, Codex, Gemini CLI, GitHub Copilot CLI, Factory Droid, or OpenCode, then re-run."
  exit 0
fi

log "Detected harnesses: ${DETECTED_HARNESSES[*]}"

# ---- Clone or update the repo ----
if [ ! -d "$INSTALL_DIR" ]; then
  log "Cloning vigilantes to $INSTALL_DIR"
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
else
  log "Vigilantes already installed at $INSTALL_DIR; pulling latest"
  (cd "$INSTALL_DIR" && git pull --ff-only origin "$BRANCH" 2>/dev/null || warn "Pull failed; using existing checkout")
fi

# ---- Wire up symlinks per harness ----
for harness in "${DETECTED_HARNESSES[@]}"; do
  case "$harness" in
    claude)
      TARGET="$HOME/.claude/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes → Claude Code ($TARGET)"
      ;;
    codex)
      TARGET="$HOME/.codex/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes → Codex ($TARGET)"
      ;;
    cursor)
      TARGET="$HOME/.cursor/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes → Cursor ($TARGET)"
      ;;
    gemini)
      TARGET="$HOME/.gemini/extensions/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes → Gemini CLI ($TARGET)"
      ;;
    copilot)
      TARGET="$HOME/.copilot/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes → GitHub Copilot CLI ($TARGET)"
      ;;
    droid)
      TARGET="$HOME/.droid/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes → Factory Droid ($TARGET)"
      ;;
    opencode)
      TARGET="$HOME/.config/opencode/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes → OpenCode ($TARGET)"
      ;;
  esac
done

log "Vigilantes installed. Restart your harness to load the plugin."
```

Make the file executable: `chmod +x scripts/install.sh`.

**Verification:** `bash -n scripts/install.sh` returns zero output (syntax check). `shellcheck scripts/install.sh` (if installed) returns no errors.

- [ ] **Step 2: Write `scripts/install.ps1`**

Create the file with the following content (PowerShell, Windows, idempotent). The logic mirrors `install.sh`:

```powershell
# Vigilantes bootstrap installer (Windows)
# Detects installed harnesses and wires up symlinks or copies.
# Idempotent: re-running is a no-op.
# Repo: https://github.com/ELith03/vigilantes

$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/ELith03/vigilantes.git"
$InstallDir = if ($env:VIGILANTES_HOME) { $env:VIGILANTES_HOME } else { Join-Path $env:USERPROFILE ".vigilantes" }
$Branch = if ($env:VIGILANTES_BRANCH) { $env:VIGILANTES_BRANCH } else { "main" }

function Log($msg) { Write-Host "[vigilantes] $msg" }
function Warn($msg) { Write-Warning "[vigilantes] $msg" }
function Fail($msg) { Write-Error "[vigilantes] FAIL: $msg"; exit 1 }

# ---- Harness detection ----
$Detected = @()
if (Get-Command claude  -ErrorAction SilentlyContinue) { $Detected += "claude" }
if (Get-Command codex   -ErrorAction SilentlyContinue) { $Detected += "codex" }
if (Get-Command cursor  -ErrorAction SilentlyContinue) { $Detected += "cursor" }
if (Get-Command gemini  -ErrorAction SilentlyContinue) { $Detected += "gemini" }
if (Get-Command copilot -ErrorAction SilentlyContinue) { $Detected += "copilot" }
if (Get-Command droid   -ErrorAction SilentlyContinue) { $Detected += "droid" }
if (Test-Path (Join-Path $env:USERPROFILE ".config\opencode")) { $Detected += "opencode" }

if ($Detected.Count -eq 0) {
    Warn "No supported harnesses detected. Install Claude Code, Cursor, Codex, Gemini CLI, GitHub Copilot CLI, Factory Droid, or OpenCode, then re-run."
    exit 0
}

Log "Detected harnesses: $($Detected -join ', ')"

# ---- Clone or update the repo ----
if (-not (Test-Path $InstallDir)) {
    Log "Cloning vigilantes to $InstallDir"
    git clone --depth 1 --branch $Branch $RepoUrl $InstallDir
} else {
    Log "Vigilantes already installed at $InstallDir; pulling latest"
    Push-Location $InstallDir
    try { git pull --ff-only origin $Branch } catch { Warn "Pull failed; using existing checkout" }
    Pop-Location
}

# ---- Wire up symlinks per harness ----
foreach ($harness in $Detected) {
    $Target = switch ($harness) {
        "claude"  { Join-Path $env:USERPROFILE ".claude\plugins\vigilantes" }
        "codex"   { Join-Path $env:USERPROFILE ".codex\plugins\vigilantes" }
        "cursor"  { Join-Path $env:USERPROFILE ".cursor\plugins\vigilantes" }
        "gemini"  { Join-Path $env:USERPROFILE ".gemini\extensions\vigilantes" }
        "copilot" { Join-Path $env:USERPROFILE ".copilot\plugins\vigilantes" }
        "droid"   { Join-Path $env:USERPROFILE ".droid\plugins\vigilantes" }
        "opencode" { Join-Path $env:USERPROFILE ".config\opencode\plugins\vigilantes" }
    }

    if (Test-Path $Target) {
        Log "$harness already linked at $Target"
        continue
    }

    # Try symlink first; fall back to copy if symlink fails (Windows requires Developer Mode or admin)
    try {
        New-Item -ItemType SymbolicLink -Path $Target -Target $InstallDir -ErrorAction Stop
        Log "Linked vigilantes → $harness ($Target)"
    } catch {
        Warn "Symlink failed for $harness; falling back to copy. Enable Developer Mode for symlinks."
        Copy-Item -Path $InstallDir -Destination $Target -Recurse
        Log "Copied vigilantes → $harness ($Target)"
    }
}

Log "Vigilantes installed. Restart your harness to load the plugin."
```

**Verification:** (Manual — Windows-only.) On a Windows machine with PowerShell, run `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install.ps1 -WhatIf` (after adding `-WhatIf` support) or just `Test-Path` checks. For CI verification, run `pwsh -Command "Get-Command -Syntax install.ps1"` (syntax check only).

- [ ] **Step 3: Smoke-test install.sh in a sandbox**

```bash
# In a clean temp directory, run with a fake HOME to avoid touching real config:
TMPHOME=$(mktemp -d)
HOME="$TMPHOME" VIGILANTES_HOME="$TMPHOME/vigilantes-checkout" bash scripts/install.sh
# Verify the clone happened:
test -d "$TMPHOME/vigilantes-checkout/.git" && echo "OK: cloned"
# Verify no symlinks were created (no harnesses detected in the sandbox):
test ! -L "$TMPHOME/.claude/plugins/vigilantes" && echo "OK: no claude symlink (expected)"
# Cleanup:
rm -rf "$TMPHOME"
```

Expected: two `OK:` lines. (No harnesses detected in the sandbox; script exits gracefully.)

- [ ] **Step 4: Commit Task 9**

```bash
git add scripts/install.sh scripts/install.ps1
git commit -m "feat(install): add bootstrap install scripts (install.sh + install.ps1)"
```

---

### Task 10: Per-harness INSTALL.md files

**Files:**
- Create: `docs/INSTALL.claude.md`
- Create: `docs/INSTALL.codex.md`
- Create: `docs/INSTALL.cursor.md`
- Create: `docs/INSTALL.copilot.md`
- Create: `docs/INSTALL.droid.md`
- Create: `docs/INSTALL.gemini.md`
- Create: `docs/INSTALL.opencode.md`

- [ ] **Step 1: Write `docs/INSTALL.claude.md`**

```markdown
# Install Vigilantes on Claude Code

## Quick install (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)
```

The script detects Claude Code and wires up a symlink at `~/.claude/plugins/vigilantes`.

Restart Claude Code after install. You should see "You have vigilantes." in the system prompt.

## Manual install

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
ln -s ~/.vigilantes ~/.claude/plugins/vigilantes
```

## Verify

Start a new Claude Code session. The first message should reference vigilantes. If you see "You have vigilantes." in the system prompt, the install succeeded.

## Uninstall

```bash
rm ~/.claude/plugins/vigilantes
rm -rf ~/.vigilantes
```

## Troubleshooting

- **Cache issue?** Clear the Claude Code plugin cache and restart.
- **Symlink permission denied?** Enable Developer Mode (macOS / Windows) or use `sudo ln -s` (Linux).
- **Still see "You have superpowers."?** Old plugin still installed. Check `~/.claude/plugins/` and remove any `superpowers` symlink.
```

- [ ] **Step 2: Write `docs/INSTALL.codex.md`** (mirror of claude, paths adjusted)

```markdown
# Install Vigilantes on Codex CLI / Codex App

## Quick install (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)
```

The script detects Codex and wires up a symlink at `~/.codex/plugins/vigilantes`.

Restart Codex after install.

## Manual install

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
ln -s ~/.vigilantes ~/.codex/plugins/vigilantes
```

## Verify

Start a new Codex session. The plugin manifest should load.

## Uninstall

```bash
rm ~/.codex/plugins/vigilantes
rm -rf ~/.vigilantes
```

## Troubleshooting

- **Codex App store conflict?** The Codex App may have its own marketplace; if it lists "superpowers" as a built-in, that is a separate upstream reference and does not affect vigilantes.
- **Cache issue?** Restart Codex; the manifest is cached briefly.
```

- [ ] **Step 3: Write `docs/INSTALL.cursor.md`**

Same template, with paths adjusted:
- Target: `~/.cursor/plugins/vigilantes`
- Restart: Cursor

- [ ] **Step 4: Write `docs/INSTALL.copilot.md`**

Same template, with paths adjusted:
- Target: `~/.copilot/plugins/vigilantes`
- Restart: GitHub Copilot CLI

- [ ] **Step 5: Write `docs/INSTALL.droid.md`**

Same template, with paths adjusted:
- Target: `~/.droid/plugins/vigilantes`
- Restart: Factory Droid

- [ ] **Step 6: Write `docs/INSTALL.gemini.md`**

Same template, with paths adjusted:
- Target: `~/.gemini/extensions/vigilantes`
- Restart: Gemini CLI

- [ ] **Step 7: Write `docs/INSTALL.opencode.md`**

Same template, with paths adjusted:
- Target: `~/.config/opencode/plugins/vigilantes`
- Restart: OpenCode

Note: `INSTALL.md` also exists at the project root inside the OpenCode plugin folder (`.opencode/INSTALL.md`). The two files are kept in sync. (This dual-location decision is per the rebrand spec's open question 4; both are kept until that question is resolved.)

- [ ] **Step 8: Verify all 7 INSTALL.md files exist**

```bash
for f in claude codex cursor copilot droid gemini opencode; do
  test -f "docs/INSTALL.${f}.md" && echo "OK: $f" || echo "MISSING: $f"
done
```

Expected: 7 `OK:` lines.

- [ ] **Step 9: Commit Task 10**

```bash
git add docs/INSTALL.claude.md docs/INSTALL.codex.md docs/INSTALL.cursor.md docs/INSTALL.copilot.md docs/INSTALL.droid.md docs/INSTALL.gemini.md docs/INSTALL.opencode.md
git commit -m "feat(install): add per-harness INSTALL.md files for all 7 harnesses"
```

---

## Phase 5: Verification

### Task 11: Acceptance test — grep sweeps + per-harness verification

This task runs the 11-item acceptance test from the rebrand spec section "Acceptance Criteria" plus per-harness verification (load the plugin in each harness and confirm the bootstrap fires).

- [ ] **Step 1: Grep sweep — "superpowers" in user-facing files**

```bash
grep -ri "superpowers" --include="*.md" --include="*.json" --include="*.sh" --include="*.ps1" --include="*.cmd" --include="*.js" . | grep -v ".git/" | grep -v "node_modules/" | grep -v "docs/superpowers/specs/" | grep -v "docs/superpowers/plans/"
```

(The exclusions are intentional: `docs/superpowers/` is the *specs/plans* directory name, not brand references; the spec files mention "superpowers" only in the rebrand spec's own context.)

Expected: zero output. If any are found, fix them and re-run.

- [ ] **Step 2: Grep sweep — "obra" in user-facing files**

```bash
grep -ri "obra" --include="*.md" --include="*.json" --include="*.sh" --include="*.ps1" --include="*.cmd" --include="*.js" . | grep -v ".git/" | grep -v "node_modules/" | grep -v "docs/superpowers/specs/" | grep -v "docs/superpowers/plans/" | grep -v "README.md"
```

(The README.md exclusion is intentional — the fork-credit paragraph names "obra/superpowers" deliberately. All other files should have zero `obra` references.)

Expected: zero output (besides README.md's intentional references).

- [ ] **Step 3: Grep sweep — "Jesse Vincent" in user-facing files**

```bash
grep -ri "jesse vincent" . | grep -v ".git/" | grep -v "node_modules/" | grep -v "docs/superpowers/specs/" | grep -v "docs/superpowers/plans/" | grep -v "README.md" | grep -v "LICENSE"
```

(The README.md and LICENSE exclusions are intentional — the fork-credit paragraph names the original author.)

Expected: zero output (besides README.md and LICENSE).

- [ ] **Step 4: Verify all 5 plugin manifests have correct name + repo URL**

```bash
for f in .claude-plugin/plugin.json .codex-plugin/plugin.json .cursor-plugin/plugin.json gemini-extension.json package.json; do
  grep -q '"name": "vigilantes"' "$f" || echo "FAIL: $f missing vigilantes name"
  grep -q "ELith03/vigilantes" "$f" || echo "FAIL: $f missing repo URL"
done
```

Expected: zero `FAIL:` lines.

- [ ] **Step 5: Verify the bootstrap text says "Vigilantes"**

```bash
grep -q "You have vigilantes" hooks/session-start && echo "OK: bootstrap text"
```

Expected: `OK: bootstrap text`.

- [ ] **Step 6: Verify the skill folder rename**

```bash
test -d skills/using-vigilantes && echo "OK: new folder"
test ! -d skills/using-superpowers && echo "OK: old folder removed"
```

Expected: both `OK:` lines.

- [ ] **Step 7: Verify the install scripts are syntactically valid**

```bash
bash -n scripts/install.sh && echo "OK: install.sh syntax"
test -f scripts/install.ps1 && echo "OK: install.ps1 exists"
```

Expected: both `OK:` lines. (Bash syntax check; PowerShell is checked on Windows.)

- [ ] **Step 8: Verify all 7 per-harness INSTALL.md files exist**

```bash
for h in claude codex cursor copilot droid gemini opencode; do
  test -f "docs/INSTALL.${h}.md" && echo "OK: $h" || echo "MISSING: $h"
done
```

Expected: 7 `OK:` lines.

- [ ] **Step 9: Verify the fork credit + origin story in README.md**

```bash
grep -q "Vigilantes" README.md && grep -q "obra/superpowers" README.md && echo "OK: fork credit"
```

Expected: `OK: fork credit`.

- [ ] **Step 10: Verify LICENSE preserves original MIT attribution**

```bash
grep -q "MIT" LICENSE && (grep -q "Jesse Vincent" LICENSE || grep -q "Prime Radiant" LICENSE) && echo "OK: MIT preserved"
```

Expected: `OK: MIT preserved`.

- [ ] **Step 11: Verify all 7 install paths point to `https://github.com/ELith03/vigilantes.git`**

```bash
grep -r "github.com/ELith03/vigilantes" docs/INSTALL.*.md scripts/install.* 2>/dev/null | wc -l
```

Expected: ≥ 7 (one per INSTALL.md + at least one in each install script). If fewer, fix the missing files.

- [ ] **Step 12: Manual per-harness verification (CANNOT BE SCRIPTED)**

For each of the 7 harnesses, perform a manual smoke test:

1. Run the install script (or follow the manual steps in the harness's INSTALL.md).
2. Restart the harness.
3. Open a new conversation.
4. Confirm the system prompt or first message references vigilantes (e.g., "You have vigilantes.").
5. Confirm at least one skill (e.g., `brainstorming`) is loadable.

This step requires the user to have access to the 7 harnesses. For the 5 commonly available (Claude Code, Cursor, Codex, Gemini, OpenCode), the user can run the verification. For Copilot CLI and Factory Droid, the user may need to ask a colleague or accept a deferred verification.

Record the result in a verification log (Step 13).

- [ ] **Step 13: Commit Task 11 (verification log)**

```bash
cat > /tmp/vigilantes-rebrand-verification.md <<'EOF'
# Vigilantes Rebrand Verification Log

Date: YYYY-MM-DD
Implementer: <name>
Spec: docs/superpowers/specs/2026-06-12-vigilantes-rebrand.md

| Check | Status | Notes |
|---|---|---|
| 1. No "superpowers" in user-facing files | PASS | <evidence> |
| 2. No "obra" (except README fork credit) | PASS | <evidence> |
| 3. No "Jesse Vincent" (except README + LICENSE) | PASS | <evidence> |
| 4. All 5 manifests correct | PASS | <evidence> |
| 5. Bootstrap text says "Vigilantes" | PASS | <evidence> |
| 6. Skill folder renamed | PASS | <evidence> |
| 7. Install scripts syntactically valid | PASS | <evidence> |
| 8. 7 per-harness INSTALL.md files | PASS | <evidence> |
| 9. Fork credit in README | PASS | <evidence> |
| 10. LICENSE preserves MIT | PASS | <evidence> |
| 11. All install paths use ELith03/vigilantes | PASS | <evidence> |
| 12. Per-harness manual smoke test | <PASS / DEFERRED> | <evidence> |
EOF

# Replace YYYY-MM-DD with today's date
sed -i "s/YYYY-MM-DD/$(date +%Y-%m-%d)/" /tmp/vigilantes-rebrand-verification.md
mv /tmp/vigilantes-rebrand-verification.md docs/superpowers/specs/2026-06-12-vigilantes-rebrand-VERIFICATION.md

git add docs/superpowers/specs/2026-06-12-vigilantes-rebrand-VERIFICATION.md
git commit -m "feat(brand): vigilantes rebrand verification log"
```

---

## Self-Review

**1. Spec coverage:** The spec lists 12 deliverables (5 manifests, 14 skill folders [1 renamed], bootstrap, install paths, 2 install scripts, 7 INSTALL.md files, README + 5 docs, 3 GitHub files, 2 internal scripts, 2 assets, fork credit paragraph, version bump, LICENSE, CODE_OF_CONDUCT). This plan covers all of them across 11 tasks. Coverage is complete.

**2. Placeholder scan:** No "TBD", "TODO", "implement later", or "fill in details" in the plan. Each step has either (a) the full file content to write inline, (b) a concrete edit instruction, or (c) a specific verification command. The only "placeholder" reference in the plan is the app-icon Step 2 of Task 1, which explicitly handles the case where the user has not yet supplied a real icon — that is a real fork in the plan, not a content gap. Pass.

**3. Type consistency:** The plan uses consistent file paths throughout (`.claude-plugin/plugin.json`, `skills/using-vigilantes/SKILL.md`, etc.). The repo URL `https://github.com/ELith03/vigilantes` is consistent across all manifests, install scripts, and INSTALL.md files. Pass.

**4. Order-of-operations check:** Skill folder rename (Task 4) is sequenced before internal text sweep (Task 5), which depends on the new folder name. Install scripts (Task 9) are sequenced before INSTALL.md files (Task 10), which the install scripts reference. Verification (Task 11) is last, depending on all prior tasks. No circular dependencies. Pass.

**5. Risk register coverage:** The plan's risk register covers 11 named risks, each with mitigation. The high-impact ones (cross-platform scripts, Windows symlinks, missed references) have specific verification steps. Pass.

## Handoff

Plan complete and saved to `docs/superpowers/plans/2026-06-12-vigilantes-rebrand.md`. Two execution options:

1. **Subagent-Driven (recommended)** — I dispatch a fresh subagent per task, review between tasks, fast iteration. Especially useful for this plan because the 11 tasks are highly parallelizable (brand assets, manifests, bootstrap, docs, scripts can all run in parallel from the start; only the skill rename + sweep and the install scripts + INSTALL.md have sequencing).
2. **Inline Execution** — Execute tasks in this session using executing-plans, batch execution with checkpoints.

**Worktree recommendation:** This rebrand is large enough to warrant a worktree. Before executing, create one via the using-git-worktrees skill:

```
git worktree add ../vigilantes-rebrand -b rebrand/vigilantes
```

All 11 tasks run in the worktree. The worktree merges to main only after Task 11 (per-harness verification) passes.

**Which approach?**

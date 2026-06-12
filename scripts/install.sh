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
      log "Linked vigilantes -> Claude Code ($TARGET)"
      ;;
    codex)
      TARGET="$HOME/.codex/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes -> Codex ($TARGET)"
      ;;
    cursor)
      TARGET="$HOME/.cursor/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes -> Cursor ($TARGET)"
      ;;
    gemini)
      TARGET="$HOME/.gemini/extensions/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes -> Gemini CLI ($TARGET)"
      ;;
    copilot)
      TARGET="$HOME/.copilot/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes -> GitHub Copilot CLI ($TARGET)"
      ;;
    droid)
      TARGET="$HOME/.droid/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes -> Factory Droid ($TARGET)"
      ;;
    opencode)
      TARGET="$HOME/.config/opencode/plugins/vigilantes"
      [ -L "$TARGET" ] || ln -s "$INSTALL_DIR" "$TARGET"
      log "Linked vigilantes -> OpenCode ($TARGET)"
      ;;
  esac
done

log "Vigilantes installed. Restart your harness to load the plugin."

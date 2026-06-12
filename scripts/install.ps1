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
        Log "Linked vigilantes -> $harness ($Target)"
    } catch {
        Warn "Symlink failed for $harness; falling back to copy. Enable Developer Mode for symlinks."
        Copy-Item -Path $InstallDir -Destination $Target -Recurse
        Log "Copied vigilantes -> $harness ($Target)"
    }
}

Log "Vigilantes installed. Restart your harness to load the plugin."

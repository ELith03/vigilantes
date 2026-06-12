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

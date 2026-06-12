# Install Vigilantes on OpenCode

## Quick install (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)
```

The script detects OpenCode and wires up a symlink at `~/.config/opencode/plugins/vigilantes`.

Restart OpenCode after install. You should see "You have vigilantes." in the system prompt.

## Manual install

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
ln -s ~/.vigilantes ~/.config/opencode/plugins/vigilantes
```

Alternatively, add the plugin directly to your `opencode.json`:

```json
{
  "plugins": [
    {"name": "vigilantes", "path": "~/.vigilantes/.opencode/plugins/vigilantes.js"}
  ]
}
```

## Verify

Start a new OpenCode session. The first message should reference vigilantes. If you see "You have vigilantes." in the system prompt, the install succeeded.

## Uninstall

```bash
rm ~/.config/opencode/plugins/vigilantes
rm -rf ~/.vigilantes
```

## Troubleshooting

- **Plugin not loading?** Ensure `opencode.json` has the vigilantes plugin listed, or the symlink exists at `~/.config/opencode/plugins/vigilantes`.
- **Cache issue?** Restart OpenCode.
- **Migration from superpowers?** Remove the old superpowers plugin: `rm -rf ~/.config/opencode/plugins/superpowers` and update `opencode.json` to remove the old plugin entry.

# Install Vigilantes on Gemini CLI

## Quick install (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)
```

The script detects Gemini CLI and wires up a symlink at `~/.gemini/extensions/vigilantes`.

Restart Gemini CLI after install.

## Manual install

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
ln -s ~/.vigilantes ~/.gemini/extensions/vigilantes
```

## Verify

Start a new Gemini CLI session. The extension should load automatically.

## Uninstall

```bash
rm ~/.gemini/extensions/vigilantes
rm -rf ~/.vigilantes
```

## Troubleshooting

- **Extension not loading?** Ensure Gemini CLI is configured to load local extensions. Check `gemini config` for extension paths.
- **Cache issue?** Restart Gemini CLI.

# Install Vigilantes on GitHub Copilot CLI

## Quick install (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)
```

The script detects GitHub Copilot CLI and wires up a symlink at `~/.copilot/plugins/vigilantes`.

Restart GitHub Copilot CLI after install.

## Manual install

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
ln -s ~/.vigilantes ~/.copilot/plugins/vigilantes
```

## Verify

Start a new GitHub Copilot CLI session. The plugin should load automatically.

## Uninstall

```bash
rm ~/.copilot/plugins/vigilantes
rm -rf ~/.vigilantes
```

## Troubleshooting

- **Marketplace only?** GitHub Copilot CLI extensions may require a marketplace. If the symlink does not load, check GitHub Copilot CLI documentation for local plugin support.
- **Cache issue?** Restart the CLI.

# Install Vigilantes on Cursor

## Quick install (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)
```

The script detects Cursor and wires up a symlink at `~/.cursor/plugins/vigilantes`.

Restart Cursor after install.

## Manual install

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
ln -s ~/.vigilantes ~/.cursor/plugins/vigilantes
```

## Verify

Start a new Cursor session. The plugin should load automatically.

## Uninstall

```bash
rm ~/.cursor/plugins/vigilantes
rm -rf ~/.vigilantes
```

## Troubleshooting

- **Marketplace conflict?** Cursor uses a built-in plugin system; if a "superpowers" entry appears in the Cursor marketplace, that is a separate upstream entry and does not affect vigilantes.
- **Cache issue?** Restart Cursor.

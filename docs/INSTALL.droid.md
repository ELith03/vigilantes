# Install Vigilantes on Factory Droid

## Quick install (recommended)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ELith03/vigilantes/main/scripts/install.sh)
```

The script detects Factory Droid and wires up a symlink at `~/.droid/plugins/vigilantes`.

Restart Factory Droid after install.

## Manual install

```bash
git clone https://github.com/ELith03/vigilantes.git ~/.vigilantes
ln -s ~/.vigilantes ~/.droid/plugins/vigilantes
```

## Verify

Start a new Factory Droid session. The plugin should load automatically.

## Uninstall

```bash
rm ~/.droid/plugins/vigilantes
rm -rf ~/.vigilantes
```

## Troubleshooting

- **Marketplace only?** Factory Droid extensions may require the Droid marketplace. If the symlink does not load, check Factory Droid documentation for local plugin support.
- **Custom path?** Set `VIGILANTES_HOME` to a custom checkout location before running the install script.

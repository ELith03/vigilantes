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

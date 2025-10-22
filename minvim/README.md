# minvim

This workspace houses an experimental NeoVim configuration that mirrors features you enjoyed in LazyVim, but keeps the code paths lightweight and easy to reason about.

## Quick Start

To try this config without touching an existing setup (e.g. the one in `~/.config/nvim`), launch NeoVim with a custom `NVIM_APPNAME`.

```sh
# from the repository root
NVIM_APPNAME=minvim nvim
```

NeoVim will look for its configuration in `~/.config/minvim` and runtime files in `~/.local/share/minvim`, allowing you to experiment safely. Set the variable per invocation or export it in a wrapper script if you want to reuse it for multiple sessions.

If you're testing straight from this repository without linking into `~/.config`, point `XDG_CONFIG_HOME` at the repo root for a throwaway session:

```sh
XDG_CONFIG_HOME=$(pwd) NVIM_APPNAME=minvim nvim
```

When you're ready for a more permanent setup, create a symlink so the app name resolves automatically:

```sh
ln -s $(pwd)/minvim ~/.config/minvim
NVIM_APPNAME=minvim nvim
```

## Layout

- `init.lua` – bootstraps Lazy.nvim and loads modules under `lua/`
- `lua/config/` – options, keymaps, autocmds, and shared settings
- `lua/plugins/` – Lazy.nvim plugin specifications grouped by topic
- `lua/lsp/` – shared language server helpers and per-language toggles
- `lua/extras/` – optional additions kept separate from the core experience
- `SUGGESTIONS.md` – approved/declined plugin ideas to keep scope visible
- `PLAN.md` – roadmap for building out the configuration

The initial modules are placeholders and will grow as features land. Edit them directly to tailor the defaults.

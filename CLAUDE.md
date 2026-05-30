# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal dotfiles repository managed with [GNU Stow](https://www.gnu.org/software/stow/). Files mirror the structure expected under `$HOME`, so `stow .` from the repo root symlinks everything into place.

## Applying changes

```bash
# Sync from remote and re-stow (handles stash/pop automatically)
./bin/sync-dotfiles.sh

# Re-stow manually after local edits
stow .
```

## Architecture

### Neovim (`.config/nvim/`)

Based on [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Single entry point at `init.lua` (~1330 lines) with two plugin layers:

- `lua/kickstart/plugins/` — upstream Kickstart plugins (autopairs, debug, gitsigns, indent_line, lint, neo-tree). Treat as near-upstream; prefer editing `custom/` instead.
- `lua/custom/plugins/` — local additions. Each file is self-contained and loaded automatically by lazy.nvim. Add new plugins here.
- `ftplugin/java.lua` — Java DAP + google-java-format configuration.

Key plugins in `custom/`: `coc.lua` (IntelliSense), `copilot.lua` (GitHub Copilot), `kulala.lua` (REST client), `helm-ls.lua` (Helm LSP), `toggleterm.lua`, `noice.lua`, `lualine.lua`.

TreeSitter parsers sometimes need manual installation inside Neovim:
```
:TSInstall tsx javascript typescript
```

### ZSH (`zsh/`)

Modular — `aliases.zsh`, `exports.zsh`, `functions.zsh`, `scripts.zsh`. These are sourced by the shell init file via stow symlinks.

`exports.zsh` sets paths for Go, Mason (Neovim LSP installer), Python virtualenv, and MANPAGER.

### TMUX (`.tmux.conf`)

Uses catppuccin theme, tmux-yank, and vim-tmux-navigator. The navigator is paired with `nvim-tmux-navigator.lua` so `<C-h/j/k/l>` moves across both pane types seamlessly.

`sesh` is installed but not yet configured (see README TODO).

## Known issues / TODO

- `resurrect` plugin is commented out — may be re-enabled for session restoration.
- `sesh` session manager is installed but not configured.
- New TreeSitter parsers added to config may not auto-install; use `:TSInstall <lang>` manually.

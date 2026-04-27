# System Configurations

This repository contains system configurations inspired by Daviwil's dotfiles and
System Crafters' resources. See the following references for more details:

- [Daviwil's dotfiles](github.com/daviwil/dotfiles)
- [System Crafters' site](https://systemcrafters.net/)
- [System Crafters' YouTube Channel](https://www.youtube.com/@SystemCrafters)

## Neovim Configuration

Experiment with Neovim configurations, including plugins and custom settings.

## TMUX Configuration

Experiment various tmux session management techniques, including the use of `sesh` for session
management and `resurrect` for session restoration.

## TODO

`sesh` is installed but not yet configured. This tool will be used to manage tmux sessions more efficiently.
resurrect is commented out for now, but may be re-enabled in the future to allow for session restoration
after system restarts or crashes.

## Installing TreeSitters

Not sure if the configuration is working, I added some parser like `tsx`, but didn't get installed
I had to manually install using `:TSInstall tsx` in neovim.

```bash
:TSInstall tsx javascript typescript
```

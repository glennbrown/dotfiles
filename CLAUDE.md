# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a [chezmoi](https://chezmoi.io) source directory for managing personal dotfiles across macOS (`darwin`) and Linux. The working directory itself (`~/.local/share/chezmoi`) is the chezmoi source state, so files here use chezmoi's naming and templating conventions rather than being live dotfiles.

Note: `README.md` is out of date. It describes an older symlink-based layout (`mac/`, `linux/`, `brewfiles/`) that no longer exists. Trust the actual files and their chezmoi naming over the README.

## chezmoi conventions

Filenames encode how chezmoi materializes them into the home directory:

- `dot_foo` -> `~/.foo`
- `private_dot_config/` -> `~/.config/` with restrictive (0600/0700) permissions
- `*.tmpl` -> rendered as a Go text/template before being written

Template data comes from `.chezmoi.toml.tmpl`, which prompts on first `chezmoi init` for `email`, `name`, `editor`, and `gitSigningKey`. These are referenced in templates as `.email`, `.name`, `.editor`, `.gitSigningKey`. OS branching uses `.chezmoi.os` (`"darwin"` vs `"linux"`).

`.chezmoiignore` is itself a template: it excludes `README.md`/`LICENSE` everywhere, and conditionally excludes files per OS (e.g. Linux hosts skip `.zprofile`, `.claude`, `.Brewfile`, ghostty/zed configs; macOS skips `.profile`, `.bashrc`, `.inputrc`).

## Common commands

```sh
chezmoi diff          # preview what would change in the home dir
chezmoi apply         # render templates and write changes to ~
chezmoi apply -v -n   # dry-run, verbose
chezmoi edit <target> # edit the source file for a target (e.g. chezmoi edit ~/.zshrc)
chezmoi cd            # open a shell in this source dir
chezmoi execute-template < file.tmpl   # test-render a template with current data
```

When editing, change the source file here (e.g. `dot_zshrc.tmpl`), then `chezmoi apply`. Do not edit the rendered files in `~` directly.

## Homebrew

`Brewfile` (rendered to `~/.Brewfile`, macOS only) is the single package manifest. Apply with:

```sh
brew bundle install --global      # uses ~/.Brewfile
brew bundle cleanup --global      # remove anything not in the Brewfile
```

## Platform handling

- Shell config is Zsh-first. macOS-specific behavior (1Password SSH agent socket, `op-ssh-sign` for git signing) is guarded by `if eq .chezmoi.os "darwin"` template blocks in `dot_zshrc.tmpl` and `dot_gitconfig.tmpl`.
- Linux-specific Zsh settings live in `private_dot_config/zsh/linux.zsh`.
- macOS system defaults are applied by the standalone scripts `bin/macos-laptop-defaults.sh` and `bin/macos-server-defaults.sh` (run manually, not via chezmoi).

## Documentation style

Per the user's global instructions: in README/docs, do not use dashes (`-` or `—`) as punctuation. Rephrase with periods, commas, or parentheses.

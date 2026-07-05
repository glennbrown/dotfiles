# dotfiles

Personal configuration files for macOS and Linux, managed with [chezmoi](https://chezmoi.io) and centered around Zsh with modern CLI tools.

## What's Included

### Shell

- **Zsh** is the primary shell on macOS, **Bash** on Linux
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) and [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) via Homebrew (macOS) or system packages (Linux)
- [Starship](https://starship.rs) prompt with a custom Arch Gradient theme, skipped on Apple Terminal and text consoles
- 50,000 line shared history with timestamps
- [fzf](https://github.com/junegunn/fzf) for fuzzy finding, backed by ripgrep
- [zoxide](https://github.com/ajeetdsouza/zoxide) as a `cd` replacement

### Terminal

- [Ghostty](https://ghostty.org) with JetBrains Mono Nerd Font and Nord theme (macOS only)
- 150x50 default window with 1Password secure input enabled

### Editors

- Chezmoi will prompt for default editor, typically I use **Zed** for macos and **Vim** with linux.
- Nano with syntax highlighting and line numbers
- Vim with with some sane defaults

### Modern CLI Replacements

| Classic | Replacement |
|---------|-------------|
| `ls`    | `eza` (with icons and group-directories-first) |
| `cat`   | `bat` |
| `cd`    | `zoxide` |
| `find`  | `fd` |
| `grep`  | `ripgrep` |
| `diff`  | `git-delta` (in git), `difftastic` |

### Git

- SSH commit signing via 1Password (macOS) or GPG key
- `delta` as the pager with side-by-side diffs and line numbers
- Auto-setup of remote tracking branches on push

### SSH and Security

- 1Password SSH Agent socket wired up automatically on local macOS sessions (skipped over SSH)
- SSH commit signing via `op-ssh-sign` on macOS

### macOS Defaults

Scripts in `bin/` configure system preferences for two machine profiles:

- `macos-laptop-defaults.sh`: trackpad, keyboard repeat, Dock (auto-hide, 36px icons), Finder (path and status bars, folders on top), screenshots (JPG to ~/Documents/Screenshots), hot corners, Safari developer tools
- `macos-server-defaults.sh`: similar but simplified, with larger Dock icons

## Setup

Install chezmoi and initialize from this repository:

```sh
chezmoi init <repo-url>
chezmoi apply
```

On first run, chezmoi will prompt for your name, email address, preferred editor, and Git signing key. These values are stored in `~/.config/chezmoi/chezmoi.toml` and reused on subsequent runs.

Install Homebrew packages (macOS only):

```sh
brew bundle install --global
```

Apply macOS system defaults (optional, run once per machine):

```sh
bash ~/.local/share/chezmoi/bin/macos-laptop-defaults.sh
# or for a server:
bash ~/.local/share/chezmoi/bin/macos-server-defaults.sh
```

## Platform Notes

Linux hosts use `~/.config/zsh/linux.zsh` for platform-specific configuration. The `~/.zprofile`, `~/.zshrc`, Ghostty config, Zed config, and Brewfile are macOS-only and excluded on Linux via `.chezmoiignore`.

## License

MIT. See [LICENSE](LICENSE) for details.

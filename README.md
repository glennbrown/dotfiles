# dotfiles

Personal configuration files for macOS and Linux, centered around Zsh with modern CLI tools.

## Structure

```
.dotfiles/
├── bin/                        # Scripts
│   ├── macos-laptop-defaults.sh
│   └── macos-server-defaults.sh
├── brewfiles/                  # Homebrew package lists
│   ├── Brewfile.laptop
│   └── Brewfile.server
├── mac/                        # macOS-specific configs
│   ├── aliases                 # Shell aliases
│   ├── bashrc                  # Bash config (legacy)
│   ├── profile                 # POSIX shell profile
│   ├── zprofile                # Zsh profile
│   ├── zshrc                   # Primary Zsh config
│   ├── nanorc                  # Nano config
│   └── ghostty/                # Ghostty terminal config
├── linux/                      # Linux-specific configs
│   └── zshrc                   # Linux Zsh config
├── starship/                   # Starship prompt themes
│   ├── starship.toml           # Active theme (Arch Gradient)
│   └── starship.toml.catppuccin
├── dircolors                   # GNU ls color definitions
├── inputrc                     # Readline config
└── vimrc                       # Vim config
```

## What's Included

### Shell

- **Zsh** is my primary shell
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-completions](https://github.com/zsh-users/zsh-completions), and [zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- [Starship](https://starship.rs) prompt with a custom Arch Gradient theme
- Bash config kept for legacy/fallback use on MacOS
- 50,000 line shared history with timestamps

### Terminal

- [Ghostty](https://ghostty.org) with JetBrains Mono Nerd Font and Nord theme
- 150x50 default window, 50,000 line scrollback

### Editors

- **Zed** as the default local editor, **Vim** over SSH
- Vim configured with syntax highlighting, 2-space indentation, and system clipboard
- Nano with syntax highlighting and line numbers

### Modern CLI Replacements

Installed via Homebrew (see Brewfiles):

| Classic | Replacement |
|---------|-------------|
| `grep`  | `ripgrep` (rg) |
| `find`  | `fd` |
| `ls`    | `eza` / `lsd` |
| `cd`    | `zoxide` |
| `du`    | `dust` / `dua` |
| `df`    | `duf` |
| `ps`    | `procs` |
| `diff`  | `difftastic` |
| `tldr`  | `tealdeer` |

Plus [fzf](https://github.com/junegunn/fzf) for fuzzy finding with ripgrep integration.

### SSH & Security

- 1Password SSH Agent integration (on local sessions)
- GPG support

### macOS Defaults

Scripts in `bin/` configure macOS system preferences for two machine profiles:

- **Laptop** -- trackpad, keyboard repeat, Dock (auto-hide, 36px icons), Finder (show path/status bars, folders on top), screenshots (JPG to ~/Documents/Screenshots), hot corners, Safari dev tools
- **Server** -- similar but simplified, larger Dock icons

### Homebrew

Two Brewfiles for different machine types:

- **Brewfile.laptop** -- ~177 packages including dev tools, GUI apps, fonts, and media utilities
- **Brewfile.server** -- ~150 packages focused on headless operation, media server stack (Plex, SABnzbd, Transmission), and monitoring

## Setup

1. Clone the repository:
   ```sh
   git clone <repo-url> ~/.dotfiles
   ```

2. Symlink configs to their expected locations:
   ```sh
   ln -s ~/.dotfiles/mac/zshrc ~/.zshrc
   ln -s ~/.dotfiles/mac/zprofile ~/.zprofile
   ln -s ~/.dotfiles/mac/profile ~/.profile
   ln -s ~/.dotfiles/mac/bashrc ~/.bashrc
   ln -s ~/.dotfiles/mac/aliases ~/.aliases
   ln -s ~/.dotfiles/mac/nanorc ~/.nanorc
   ln -s ~/.dotfiles/vimrc ~/.vimrc
   ln -s ~/.dotfiles/inputrc ~/.inputrc
   ln -s ~/.dotfiles/dircolors ~/.dircolors
   ln -s ~/.dotfiles/starship/starship.toml ~/.config/starship.toml
   ln -s ~/.dotfiles/mac/ghostty ~/.config/ghostty
   ```
   On Linux, use `linux/zshrc` instead of `mac/zshrc`.

3. Install Homebrew packages:
   ```sh
   brew bundle install --file=~/.dotfiles/brewfiles/Brewfile.laptop
   ```

4. Apply macOS defaults (optional):
   ```sh
   bash ~/.dotfiles/bin/macos-laptop-defaults.sh
   ```

## License

MIT -- see [LICENSE](LICENSE) for details.

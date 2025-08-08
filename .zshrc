# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# SSH Agent config
#zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain

# iTerm2 Plugin config
# zstyle :omz:plugins:iterm2 shell-integration yes

# oh-my-zsh plugins
plugins=(1password aliases brew command-not-found docker fzf macos nvm tmux zoxide zsh-autosuggestions zsh-history-substring-search)

# Command completion
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# User configuration

# Allow history search via up/down keys.
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Include alias file (if present) containing aliases for ssh, etc.
test -e ${HOME}/.aliases && source ~/.aliases

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

# Starship Prompt
eval "$(starship init zsh)"

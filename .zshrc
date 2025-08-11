# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set oh-my-zsh theme when startship is not installed
if [ ! -x "$(command -v starship)" ]; then
  export ZSH_THEME="gentoo"
else
  export ZSH_THEME=""
fi

# SSH Agent config
# zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain

# iTerm2 Plugin config
# zstyle :omz:plugins:iterm2 shell-integration yes

# oh-my-zsh plugins
plugins=(1password aliases brew command-not-found docker fzf macos nvm tmux zoxide)

# Command completion
fpath+=$(brew --prefix)/share/zsh-completions

source $ZSH/oh-my-zsh.sh

# User configuration

# Allow history search via up/down keys.
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Autosuggestions
source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

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
test -e $(command -v starship) && eval "$(starship init zsh)"

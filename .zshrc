# @.zshrc
# Zsh configuration file

# Terminal
export TERM=xterm-256color

# Homebrew Settings
export HOMEBREW_AUTO_UPDATE_SECS=604800 #Update homebrew once a week
export HOMEBREW_NO_ANALYTICS=1 #Disable homebrew analytics

# History
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=$HOME/.zsh_history

# 1Password SSH Agent
export SSH_AUTH_SOCK="~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set oh-my-zsh theme when startship is not installed
if [ ! -x "$(command -v starship)" ]; then
  export ZSH_THEME="gentoo"
else
  export ZSH_THEME=""
fi

# oh-my-zsh plugins
plugins=(1password aliases brew)

# Command completion
fpath+=$(brew --prefix)/share/zsh-completions

source $ZSH/oh-my-zsh.sh

# User configuration

# Allow history search via up/down keys.
source $(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Autosuggestions
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# Include alias file (if present) containing aliases for ssh, etc.
test -e $HOME/.aliases && source ~/.aliases

# Delete a given line number in the known_hosts file.
knownrm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

# Homebrew command-not-found
HOMEBREW_COMMAND_NOT_FOUND_HANDLER="$(brew --repository)/Library/Homebrew/command-not-found/handler.sh"
if [ -f "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER" ]; then
  source "$HOMEBREW_COMMAND_NOT_FOUND_HANDLER";
fi

# Set up fzf key bindings and fuzzy completion
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_COLORS="bg+:-1,\
fg:gray,\
fg+:white,\
border:black,\
spinner:0,\
hl:yellow,\
header:blue,\
info:green,\
pointer:red,\
marker:blue,\
prompt:gray,\
hl+:red"
export FZF_DEFAULT_OPTS="--height 70% \
--border sharp \
--layout reverse \
--color '$FZF_COLORS' \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"
source <(fzf --zsh)

# Python Fix
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Surpress Node Warnings
export NODE_NO_WARNINGS=1

# Set zoxide
eval "$(zoxide init zsh)"

# Starship Prompt
test -e $(command -v starship) && eval "$(starship init zsh)"

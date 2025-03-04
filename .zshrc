# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/gbrown/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="gentoo"

# SSH Agent config
#zstyle :omz:plugins:ssh-agent ssh-add-args --apple-load-keychain

# iTerm2 Plugin config
zstyle :omz:plugins:iterm2 shell-integration yes

#Terminal autocomplete fix
#autoload -Uz compinit && compinit

# oh-my-zsh plugins
plugins=(macos command-not-found brew aliases 1password iterm2 tmux fzf zoxide docker)

# Command completion
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# User configuration

# Allow history search via up/down keys.
source ${HOMEBREW_PREFIX}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
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

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Git aliases
# Disabled git plugin has too many aliases
alias gs='git status'
alias gc='git commit'
alias gp='git pull --rebase'
alias gcam='git commit -am'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

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


#1password SSH Agent
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

#Ansible lookup url fix
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

#Surpress Node Warnings
export NODE_NO_WARNINGS=1

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Opt out of Homebrew Analytics
export HOMEBREW_NO_ANALYTICS=1

# iTerm Shell Integration
# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Atuin
eval "$(atuin init zsh)"

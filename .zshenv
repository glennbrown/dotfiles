###############################
# EXPORT ENVIRONMENT VARIABLE #
###############################

# Terminal
export TERM=xterm-256color

# History
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=$HOME/.zsh_history

# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

FZF_COLORS="bg+:-1,\
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

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Opt out of Homebrew Analytics
export HOMEBREW_NO_ANALYTICS=1

# 1Password SSH Agent
export SSH_AUTH_SOCK="~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Python Fix
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Surpress Node Warnings
export NODE_NO_WARNINGS=1
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# EnvVars
export EDITOR=vim
export HISTFILESIZE=20000
export HISTSIZE=10000
export HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTTIMEFORMAT="%a %d %b %T: "
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_DIRTRIM=3


# Include Git Branch
autoload -Uz vcs_info
precmd () { vcs_info }
zstyle ':vcs_info:*' formats '[%F{green}%b%f]'
setopt PROMPT_SUBST
PROMPT='%F{blue}%3~%f ${vcs_info_msg_0_} $ '


# direnv
eval "$(direnv hook zsh)"


# nvm
export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"


# Virtualenv
eval "$(pyenv init -)"


# Allow # in terminal
setopt interactive_comments


# Case Insensitive Matching
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Load aliases file
if [ -f ~/.sh_aliases ]; then
. ~/.sh_aliases
fi


# Load functions file
if [ -f ~/.sh_fxs ]; then
. ~/.sh_fxs
fi

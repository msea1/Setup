# ~/.bashrc: executed by bash(1) for non-login shells.


# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [[ -f ~/.git-completion.bash ]]; then
    source ~/.git-completion.bash
fi
complete -o default -o nospace -F _git g


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"


### COLORS ###
WHITE="\e[38;5;15m\]"
GREY="\e[38;5;241m\]"
RED="\e[38;5;1m\]"
YELLOW="\e[38;5;11m\]"
GREEN="\e[38;5;46m\]"
BLUE="\e[38;5;33m\]"
PURPLE="\e[38;5;93m\]"


### ENVIRONMENT VARIABLES ###
export EDITOR=vim
export HISTCONTROL=ignoreboth  # don't put duplicate lines or lines starting with space in the history.
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTFILESIZE=20000
export HISTSIZE=10000
export HISTTIMEFORMAT="%a %d %b %T: "
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_DIRTRIM=3

### PROMPT
PS1="\[$RED\$(parse_vpn)\[$PURPLE[\w] \[$YELLOW\$(parse_git_branch) \[$WHITE\\$ \[$(tput sgr0)\]"


### OPTIONS ###
shopt -s cdspell  # Autocorrect fudged paths in cd calls
shopt -s checkwinsize  # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s cmdhist
shopt -s dotglob
shopt -s extglob
shopt -s histappend  # append to the history file, don't overwrite it

set completion-ignore-case On
set show-all-if-ambiguous On


### PATHS ###
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH


### ALIASES ###
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi


### FUNCTIONS ###
if [ -f ~/.bash_fxs ]; then
. ~/.bash_fxs
fi


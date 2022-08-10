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
export HISTFILESIZE=20000
export HISTSIZE=10000
export HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTTIMEFORMAT="%a %d %b %T: "
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_DIRTRIM=3

# PS1="\[$BLUE[${PWD#"${PWD%/*/*}/"}] \[$(tput sgr0)\]\[$GREEN\$(parse_git_branch) \[$(tput sgr0)\]\[$WHITE\\$ \[$(tput sgr0)\]"
# PS1="\[$BLUE[\w] \[$(tput sgr0)\]\[$GREEN\$(parse_git_branch) \[$(tput sgr0)\]\[$WHITE\\$ \[$(tput sgr0)\]"
if [ $(hostname) == "x1" ];
then # laptop
  PS1="\[$RED\$(parse_vpn)\[$PURPLE[\w] \[$YELLOW\$(parse_git_branch) \[$WHITE\\$ \[$(tput sgr0)\]"
else # desktop
  PS1="\[$RED\$(parse_vpn)\[$BLUE[\w] \[$GREEN\$(parse_git_branch) \[$WHITE\\$ \[$(tput sgr0)\]"
fi


### OPTIONS ###
shopt -s cdspell  # Autocorrect fudged paths in cd calls
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s extglob
shopt -s histappend

set completion-ignore-case On
set show-all-if-ambiguous On


### PATHS ###
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
# export PYTHONPATH=""  # add main repo path here
export PSQL_DATA=/home/mcarruth/Code/psql_data


### ALIASES ###
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi


### FUNCTIONS ###
if [ -f ~/.bash_fxs ]; then
. ~/.bash_fxs
fi


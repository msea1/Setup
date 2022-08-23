# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


### ENVIRONMENT VARIABLES ###
export EDITOR=vim
export HISTFILESIZE=20000
export HISTSIZE=10000
export HISTCONTROL=ignoredups
export HISTIGNORE="&:ls:[bf]g:exit"
export HISTTIMEFORMAT="%a %d %b %T: "
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_DIRTRIM=3

autoload -Uz vcs_info
precmd () { vcs_info }
zstyle ':vcs_info:*' formats '(%F{green}%b%f)'

PS1="%F{blue}%3~%f $vcs_info_msg_0_ $ "


### OPTIONS ###
setopt interactive_comments


### PATHS ###


### ALIASES ###
if [ -f ~/.sh_aliases ]; then
. ~/.sh_aliases
fi


### FUNCTIONS ###
if [ -f ~/.sh_fxs ]; then
. ~/.sh_fxs
fi


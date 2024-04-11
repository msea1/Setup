# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
HISTORY_IGNORE="(ls|cd|pwd|exit|cd|g)*"
HIST_STAMPS="yyyy-mm-dd"

setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.


# EnvVars
export EDITOR=vim
export PATH="/Users/matthew/bin:$PATH"
export PATH="/Users/matthew/node_modules/.bin/:$PATH"
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export PROMPT_DIRTRIM=3


# Include Git Branch
autoload -Uz vcs_info
precmd () { vcs_info }
zstyle ':vcs_info:*' formats '[%F{green}%b%f] '
setopt PROMPT_SUBST
PROMPT='%B%F{091}%3~%f%b ${vcs_info_msg_0_}$ '


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


# Fuzzy Search
plugins=(git fzf)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='ag --hidden -g ""'

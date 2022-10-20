### ALIASES ###

# IMPROVE DEFAULTS
alias diskspace="du -S | sort -n -r |more"
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -pv'
alias wget='wget -c'

# FOLDER SHORTCUTS
alias backend="cd ~/Code/Crescendo/Backend"
alias cd..="cd .."
alias code='cd ~/Code'
alias frontend="cd ~/Code/Crescendo/Frontend"
alias tempd='cd ~/Temp'

# NEW COMMANDS
alias autofix='./scripts/lint/autofix'
alias covtest='poetry run pytest -v --cov --cov-report term-missing:skip-covered --durations=0 --durations-min=0.25'
alias gitpersonal='git config user.email carruthm@gmail.com'
alias gitwork='git config user.email Matthew@crescendohealth.co'
alias ipy='ipython --profile-dir .ipython
alias lint_check='./scripts/lint/check'
alias ld='ls -ABF --color=auto'
alias ll='ls -AhlF --color=auto'
alias pretty_json='pbpaste | jq . | pbcopy'
alias refresh_shell='source ~/.zshrc'
alias root="sudo su -"
alias sorry='sudo $(fc -ln -1)'
alias sudo_pw='cat ~/.sudo_pw | xsel -ib'

# SHORTCUTS
alias g='git'
alias gps='pgrep -a'
alias h='history | grep'
alias pip='pip3'
alias py='python3'

# MACHINES

# EDITING
alias gst='g st'

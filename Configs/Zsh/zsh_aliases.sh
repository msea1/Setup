### ALIASES ###

# IMPROVE DEFAULTS
alias diskspace="du -S | sort -n -r |more"
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -pv'
alias wget='wget -c'

# FOLDER SHORTCUTS
alias cd..="cd .."
alias code='cd ~/Code'
alias tempd='cd ~/Temp'

# NEW COMMANDS
alias covtest='poetry run pytest -cov --cov-report term-missing:skip-covered --durations=0 --durations-min=0.25'
alias gitpersonal='git config user.email carruthm@gmail.com'
alias gitwork='git config user.email Matthew@crescendohealth.co'
alias ld='ls -ABF --color=auto'
alias ll='ls -AhlF --color=auto'
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

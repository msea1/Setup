### ALIASES ###

# IMPROVE DEFAULTS
alias diskspace="du -S | sort -n -r |more"
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias mkdir='mkdir -pv'
alias wget='wget -c'

# FOLDER SHORTCUTS
alias backend="cd ~/Code/Crescendo/crescendo-backend"
alias cd..="cd .."
alias code='cd ~/Code'
alias frontend="cd ~/Code/Crescendo/crescendo-frontend"
alias tempd='cd ~/Temp'

# NEW COMMANDS
alias autofix='./scripts/lint/autofix'
alias covtest='poetry run pytest -v --cov --cov-branch --cov-report term-missing:skip-covered --durations=10 --durations-min=0.25'
alias ipy='ipython --profile-dir .ipython'
alias json_pretty='pretty_json'
alias lint_check='./scripts/lint/check'
alias ld='ls -ABF --color=auto'
alias ll='ls -AhlF --color=auto'
alias pretty_json='pbpaste | jq --indent 4 -S . | pbcopy'
alias refresh_shell='source ~/.zshrc'
alias root="sudo su -"
alias run_prod='AWS_PROFILE=production-rw ./scripts/ecs/exec'
alias run_stage='AWS_PROFILE=staging-rw ./scripts/ecs/exec'
alias sorry='sudo $(fc -ln -1)'
alias sudo_pw='cat ~/.sudo_pw | xsel -ib'
alias unwrap="git diff --name-only --diff-filter=ACMRU HEAD -- '*.py' | xargs ruff format"

# SHORTCUTS
alias g='git'
alias gps='pgrep -a'
alias gst='g st'
alias h='history | grep'
alias pip='pip3'
alias py='python3'

# MACHINES

# EDITING


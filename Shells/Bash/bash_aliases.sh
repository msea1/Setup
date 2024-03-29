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
alias tempd='cd ~/Misc'

# NEW COMMANDS
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias docker_list='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias docker_stop='docker rm -f -v $(docker ps -a -q)'
alias ld='ls -ABF --group-directories-first --color=auto'
alias ll='ls -AhlF --group-directories-first --color=auto'
alias files='xdg-open . &>/dev/null &'
alias root="sudo su -"
alias sorry='sudo $(fc -ln -1)'
alias sudo_pw='cat ~/.sudo_pw | xsel -ib'
alias update='sudo_pw && sudo apt update && sudo apt -y upgrade && sudo apt dist-upgrade && sudo apt autoremove'
alias usb_f5='sudo usbmuxd -u -U usbmux'

# SHORTCUTS
alias g='git'
alias gps='pgrep -a'
alias h='history | grep'
alias pip='pip3'
alias py='python3'

# MACHINES

# EDITING
alias bashalias='subl ~/.bash_aliases'
alias bashfx='subl ~/.bash_fxs'
alias bashrc='subl ~/.bashrc'
alias gitconfig='subl ~/.gitconfig'

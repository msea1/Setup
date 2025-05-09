#!/bin/zsh

### FUNCTIONS ###
author_by_file() {
  IFS=$'\n'
  cd "$1"
  LIST=""
  for i in $(find . -iname "*.$2"); do
    LIST="`git blame --line-porcelain "$i" | grep 'author ' | sed "s,author,," | tr -d ' '`
    $LIST"
  done
  echo "$LIST" | sort | uniq -ic | sort -nr
  unset IFS
}

branch_cov() {
  FILES=$(git diff --name-only main...HEAD -- '*.py' | paste -sd "," -)
  if [ -z "$FILES" ]; then
    echo "No Python files changed."
  else
    pytest --cov=$FILES --cov-report=xml
    diff-cover coverage.xml --compare-branch=main
  fi
}

chromy() {
  TEMP="$(mktemp -d -- "/tmp/chromium-XXXXXX")"
  echo "Running chrome with user-data-dir=$TEMP"
  trap "rm -rf -- '$TEMP'" INT TERM EXIT
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --user-data-dir="$TEMP" \
		   --no-default-browser-check \
		   --no-first-run \
		   --incognito \
		   "$@" >/dev/null 2>&1
}

del_br() {
  local d=$(git rev-parse --abbrev-ref HEAD)
  g co main
  g branch -D $d
}

del_rm_br() {
  # This is a dry run by default; you must pass --go to perform the actual deletions.
  remote_branches=$(git branch -aavv | grep matthew | sed -E 's#.*remotes/origin/(matthew[^[:space:]]*).*#\1#')
  for remote_branch in $remote_branches; do
    echo "Deleting remote branch $remote_branch"
    if [ "$1" = "--go" ]; then
      git push origin --delete $remote_branch
    fi
  done

  if [ "$1" != "--go" ]; then
    echo "This was a dry run. Pass --go to this command to actually delete the branches."
  fi
}

extract() {
 if [ -f $1 ] ; then
   case $1 in
     *.tar.bz2)   tar xvjf $1    ;;
     *.tar.gz)    tar xvzf $1    ;;
     *.bz2)       bunzip2 $1     ;;
     *.rar)       unrar x $1       ;;
     *.gz)        gunzip $1      ;;
     *.tar)       tar xvf $1     ;;
     *.tbz2)      tar xvjf $1    ;;
     *.tgz)       tar xvzf $1    ;;
     *.zip)       unzip $1       ;;
     *.Z)         uncompress $1  ;;
     *.7z)        7z x $1        ;;
     *.xz)        xz -d $1        ;;
     *)           echo "don't know how to extract '$1'..." ;;
   esac
 else
   echo "'$1' is not a valid file!"
 fi
}

gcheck() {
    git checkout matthew/$1
}

new_br() {
  git checkout -b matthew/$1
}

pretty_json_files() {
	# alternate, replaced by one-line in-place alias
	# tempd
	# pbpaste > ./pretty_json.json
	# cat ./pretty_json.json | jq . | sponge ./pretty_json.json
	# subl ./pretty_json.json
	# rm ./pretty_json.json
	# cd -
}

release_diff() {
  # show changes in dir from $1 to $2
  echo Commits
  g log --reverse --pretty="format:%h %s (%an)" $1..$2 -- ./
  echo
  echo Files Changed
  g diff --name-only $1 $2 ./
}

reset_origin() {
  local d=$(git rev-parse --abbrev-ref HEAD)
  g stash
  g fetch --prune
  g reset --hard origin/$d
  g su
}

search() {
  ag -Q -i "$1" -G "$2"$
}

search_all() {
	ag -i "$1" .* .
}

search_code() {
  ag -Q -i "$1" -G "$2"$ --ignore-dir="*test*"
}

search_files() {
  local d="ag -l -Q -i \"${2}\" -G \"${1}\""
  for var in "${@:3}"; do
    d="$d | xargs ag -l -Q -i \"$var\""
  done
  eval "$d"
}

ssh_personal() {
	git config user.name "Matthew Carruth"
	git config user.email "carruthm@gmail.com"
	ssh-add -d ~/.ssh/crescendo_ssh
	ssh-add --apple-use-keychain ~/.ssh/gmail_ssh
}

ssh_work() {	
	git config user.name "Matthew Carruth"
	git config user.email "matthew@crescendohealth.co"
	ssh-add -d ~/.ssh/gmail_ssh
	ssh-add --apple-use-keychain ~/.ssh/crescendo_ssh
}

up(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

upd_brew() {
  brew update
  brew upgrade
}

upd_configs() {
  cp ~/.zshrc ~/Code/Personal/Setup/Shells/Zsh/zshrc.sh
  cp ~/.sh_aliases ~/Code/Personal/Setup/Shells/Zsh/zsh_aliases.sh
  cp ~/.sh_fxs ~/Code/Personal/Setup/Shells/Zsh/zsh_functions.sh
  cd ~/Code/Personal/Setup/
  ssh_personal
}

upd_main() {
  local d=$(git rev-parse --abbrev-ref HEAD)
  git stash push -m 'changes on ${d}'
  git checkout main
  git fetch --prune
  git reset --hard
  git rebase
  git submodule update
  if [ ${PWD##*/} = "crescendo-backend" ];
    then
      work
      poetry install
	# ./scripts/migrate/local
  fi
  if [ ${PWD##*/} = "crescendo-frontend" ];
    then
      npm install
      git reset --hard
  fi
  git checkout $d
}

using_port() {
	sudo lsof -i :$1
}

work() {
  backend
  source ./.venv/bin/activate
}

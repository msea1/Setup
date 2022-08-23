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

del_br() {
  local d=$(git rev-parse --abbrev-ref HEAD)
  g co master
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

extract () {
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

new_venv() {
  py -m venv $HOME/.virtualenvs/$1
  work $1
}

release_diff() {
  # show changes in dir from $1 to $2
  echo Commits
  # g log --reverse --oneline $1..$2 -- ./
  g log --reverse --pretty="format:%h %s (%an, %ar)" $1..$2 -- ./
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

upd_master() {
  pushd -n $(pwd)
  local d=$(git rev-parse --abbrev-ref HEAD)
  g stash
  g co master
  g fetch --prune
  g reset --hard
  g rebase
  g submodule update
  g co $d
  popd
}

work() {
  source $HOME/.virtualenvs/$1/bin/activate
}

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

new_br() {
	git checkout -b matthew/$1
	if [[ $(git status --short) ]]; then
		git aa
		git cm 'WIP: carryover'
	fi
	black -q -C --preview -l 125 .
	git aa
	git cm 'black_commit_to_revert'
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

rebase_main() {
	local d=$(git rev-parse --abbrev-ref HEAD)
    # create new black from latest main
	upd_main
	git co main
	new_br main_125
    
    # ID previous black commit
    git checkout $d
    drop=$(g log --oneline HEAD~50..HEAD | grep black_commit_to_revert | cut -d " " -f 1)
    
    # rebase on new black
    git rebase -i --onto matthew/main_125 $drop
    
    # remove temp branch
	git branch -D matthew/main_125
}

release_diff() {
    repo=${PWD##*/}
    repo=${result:-/}
	git fetch -p
	prod=$(git show -s --pretty='format:%h' origin/production)
	main=$(git show -s --pretty='format:%h' origin/main)
	echo "$repo - changes between Production (\`$prod\`) and Main (\`$main\`)"
    echo "https://github.com/CrescendoHealth/crescendo-${repo:l}/compare/$prod...$main"
	echo "\`\`\`"
	git --no-pager log --reverse --pretty="format:%h %<(10)%aN: %<(100,mtrunc)%s" "$prod".."$main"
	echo ""
	echo "\`\`\`"
}

release_diff_full() {
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


upd_all() {
	pushd -n $(pwd)
	
	backend
  upd_main

	frontend
  upd_main
	
	popd
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
}


upd_main() {
  local d=$(git rev-parse --abbrev-ref HEAD)
  git stash push -m 'changes on ${d}'
  git checkout main
  git fetch --prune
  git reset --hard
  git rebase
  git submodule update
	# if [ ${PWD##*/} = "Backend" ];
	# 	then
	# 		./scripts/migrate/local
	# fi
  git checkout $d
}


using_port() {
	sudo lsof -i :$1
}


work() {
	backend
  source ./.venv/bin/activate
}

# Local Dev Sandbox

### Create External Tool
echo """
pushd -n $(pwd)
cd $1
/Users/matthew/Code/Crescendo/Backend/.venv/bin/black --preview --line-length $2 -C $3
popd"" >> ~/bin/local_black

### Create External Tool in IDEA
https://www.jetbrains.com/help/idea/configuring-third-party-tools.html
Program: `local_black`
Arguments: `$FileDir$ 88 $FileName$`

### Assign Keymap
Cmd + Ctrl + B / S (88), M (100), L (145)

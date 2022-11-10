# Local Dev

## Environments
new_venv archive
pip install --upgrade pip
pip install wheel setuptools black bandit isort semgrep flake8 mypy

new_venv personal
pip install --upgrade pip
pip install wheel setuptools black bandit isort semgrep flake8 mypy

new_venv work
pip install --upgrade pip
pip install wheel setuptools black bandit isort semgrep flake8 mypy


### Create External Tool
echo """pushd -n $(pwd)
cd $1
/home/matthew/.virtualenvs/work/bin/black --preview --line-length $2 -C $3
popd
""" >> ~/bin/local_black
sudo chmod 555 ~/bin/local_black

### Create External Tool in IDEA
https://www.jetbrains.com/help/idea/configuring-third-party-tools.html
Program: `local_black`
Arguments: `$FileDir$ 88 $FileName$`

### Assign Keymap
Cmd + Ctrl + B / S (88), M (100), L (145)

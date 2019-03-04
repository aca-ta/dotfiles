#!/bin/bash

install_python(){
  if [[ ! -e ${HOME}/.pyenv ]]; then
    git clone git://github.com/yyuu/pyenv.git ~/.pyenv
  fi

  sudo apt install -y git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev zlib1g-dev

  CONFIGURE_OPTS="--enable-shared" pyenv install 3.7.0
  pyenv global 3.7.0
  pyenv rehash
  pip install pipenv pylint mypy
}

install_go(){
  if [[ ! -e ${HOME}/.goenv ]]; then
    git clone https://github.com/syndbg/goenv.git ~/.goenv
  fi
  ~/.goenv/bin/goenv install 1.11.5
  ~/.goenv/bin/goenv global 1.11.5
  ~/.goenv/bin/goenv rehash
}

install_youcompleteme(){
  sudo apt install -y build-essential cmake
  ~/.vim/plugged/YouCompleteMe/install.py --go-completer
}

sudo apt update && sudo apt upgrade
sudo apt install -u zsh tmux tig
install_python
install_youcompleteme
install_go

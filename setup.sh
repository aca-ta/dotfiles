#!/bin/bash

install_python(){
  git clone git://github.com/yyuu/pyenv.git ~/.pyenv

  sudo apt install -y git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev zlib1g-dev

  CONFIGURE_OPTS="--enable-shared" pyenv install 3.7.0
  pyenv global 3.7.0
  pyenv rehash
  pip install pipenv pylint mypy
}

install_go(){
  git clone https://github.com/syndbg/goenv.git ~/.goenv
  goenv install 1.11.5
  goenv global 1.11.5
  goenv rehash
}

install_youcompleteme(){
  sudo apt install -y build-essential cmake
  ~/.vim/plugged/YouCompleteMe/install.py
}

sudo apt update && sudo apt upgrade
sudo apt install -u zsh tmux tig
install_python
install_youcompleteme
install_go

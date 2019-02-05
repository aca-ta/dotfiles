#!/bin/bash

sudo apt install zsh tmux

# zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

# pyenv
git clone git://github.com/yyuu/pyenv.git ~/.pyenv

sudo apt install -y git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev zlib1g-dev

CONFIGURE_OPTS="--enable-shared" pyenv install 3.7.0

# YouCompleteMe
sudo apt install -y build-essential cmake

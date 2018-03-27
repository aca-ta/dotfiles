#!/bin/bash

if [ ! -e ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

mkdir -p /home/vagrant/.vim/colors
vim +'PlugInstall --sync' +qa

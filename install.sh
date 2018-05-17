#!/bin/bash

if [ ! -e ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

mkdir -p /home/vagrant/.vim/colors
vim +'PlugInstall --sync' +qa

curl https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh
curl https://github.com/git/git/blob/master/contrib/completion/git-completion.bash > ~/.git-compeletion.bash

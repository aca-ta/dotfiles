#!/bin/bash

cp ./vimrc ~/.vimrc
if [ ! -e ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

mkdir -p /home/vagrant/.vim/colors
vim +'PlugInstall --sync' +qa

cp ./tmux.conf ~/.tmux.conf

curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/.git-prompt.sh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ~/.git-compeletion.bash

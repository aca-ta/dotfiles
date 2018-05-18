#!/bin/bash

set_symlinks() {

  for file in $(ls ./etc)
  do
    rm -f ${HOME}/.${file}
    ln -s $(pwd)/etc/${file} ~/.${file}
  done
}


fetch_git_completions(){

  curl -fLo ${HOME}/.git-prompt.sh \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
  curl -fLo ${HOME}/.git-completion.bash \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
}


install_vim_plugins(){

  rm -r ${HOME}/.vim/autoload/plug.vim
  mkdir -p ${HOME}/.vim/autoload
  mkdir -p ${HOME}/.vim/colors

  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  
  vim +'PlugInstall --sync' +qa
}


set_symlinks
fetch_git_completions
install_vim_plugins

source ${HOME}/.bashrc 

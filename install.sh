#!/bin/bash

set_symlink() {

  local file=${1}
  
  rm -f ${HOME}/.${file}
  ln -s $(pwd)/etc/${file} ~/.${file}
}

install_vim_plugins(){

  rm -r ${HOME}/.vim/autoload/plug.vim
  mkdir -p ${HOME}/.vim/autoload
  mkdir -p ${HOME}/.vim/colors

  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  
  vim +'PlugInstall --sync' +qa
}

fetch_git_completions(){

  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ${HOME}/.git-prompt.sh
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > ${HOME}/.git-completion.bash
}

for file in $(ls ./etc)
do
  set_symlink ${file}
done

install_vim_plugins
fetch_git_completions

source ${HOME}/.bashrc 

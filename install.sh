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

fetch_dircolors(){
  curl -fLo ${HOME}/.dircolors.256dark \
      https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
}

install_vim_plugins(){

  rm -r ${HOME}/.vim/autoload/plug.vim
  mkdir -p ${HOME}/.vim/autoload
  mkdir -p ${HOME}/.vim/colors

  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  
  vim +'PlugInstall --sync' +qa
}

install_zplug() {
  if [[ ! -e ${HOME}/.zplug ]]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    chmod -R 775 ${HOME}/.zplug
  fi
}


set_symlinks
fetch_git_completions
fetch_dircolors
install_vim_plugins
install_zplug


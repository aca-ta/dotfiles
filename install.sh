#!/bin/bash

set_symlinks() {
    source ./set_symlink.sh

}

fetch_git_completions(){

  curl -fLo ${HOME}/.git-prompt.sh \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
  curl -fLo ${HOME}/.git-completion.bash \
      https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
}

set_git_secrets(){
    brew install git-secrets
    git secrets --register-aws --global
    git secrets --add 'private_key' --global
    git secrets --add 'private_key_id' --global
}

fetch_dircolors(){
  curl -fLo ${HOME}/.dircolors.256dark \
      https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark
}

install_template() {
  rm -f ${HOME}/.vim/template
  ln -s $(pwd)/template  ${HOME}/.vim/template

  # nvim
  rm -f ${HOME}/.config/nvim/templates
  ln -s $(pwd)/template  ${HOME}/.config/nvim/templates
}

install_vim_plugins(){

  rm -r ${HOME}/.vim/autoload/plug.vim
  mkdir -p ${HOME}/.vim/autoload
  mkdir -p ${HOME}/.vim/colors

  curl -fLo ${HOME}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  
  vim +'PlugInstall --sync' +qa

  # nvim
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

install_zplug() {
    case "${OSTYPE}" in
        darwin*)
            ;;
        *)
            sudo apt install locales-all
    esac
    if [[ ! -e ${HOME}/.zplug ]]; then
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
        chmod -R 775 ${HOME}/.zplug
    fi
}


install_coc_nvim() {
    local coccommnmd='CocInstall -sync coc-pyright coc-json coc-tsserver coc-prettier coc-eslint @yaegassy/coc-volar coc-go coc-sh coc-pairs coc-java coc-lua'
    vim +"$coccommnmd" +qa
}

set_symlinks
set_git_secrets
fetch_git_completions
fetch_dircolors
install_template
install_vim_plugins
install_zplug
install_coc_nvim

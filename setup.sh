#!/bin/bash

install_tools(){
  case "${OSTYPE}" in
    darwin*)
      brew update
      brew install zsh tmux reattach-to-user-namespace tig bat fzf coreutils gnu-tar fd lsd rg cmake jq lsd nvm battery
      ;;
    *)

      # install newer vim
      sudo add-apt-repository ppa:jonathonf/vim

      sudo apt update && sudo apt upgrade
      sudo apt install build-essential make
      brew install zsh tmux tig bat fzf fd lsd gnu-tar gnu-sed

      # enable zsh
      command -v zsh | sudo tee -a /etc/shells
      sudo chsh -s "$(command -v zsh)" "${USER}"

      # enable fzf key-bindings
      $(brew --prefix)/opt/fzf/install

      # install rg
      curl -LO https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb
      sudo dpkg -i ripgrep_11.0.2_amd64.deb
  esac
}

install_terraform(){
    brew install tfenv terraform-ls
}

install_python(){
  brew install pyenv
  # setup build environment
  # https://github.com/pyenv/pyenv/wiki#suggested-build-environment
  case "${OSTYPE}" in
    darwin*)
      brew install openssl readline sqlite3 xz zlib tcl-tk
      ;;
    *)
      sudo apt update; sudo apt install -y make build-essential libssl-dev zlib1g-dev \
      libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
      libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
      sudo apt install python3-dev
  esac

  pyenv install 3.9.14
  pyenv global 3.9.14
  pyenv rehash
  pip install pipenv pylint mypy
}

install_go(){
  if [[ ! -e ${HOME}/.goenv ]]; then
    git clone https://github.com/syndbg/goenv.git ~/.goenv
  fi
  ~/.goenv/bin/goenv install 1.12.7
  ~/.goenv/bin/goenv global 1.12.7
  ~/.goenv/bin/goenv rehash
}

install_nodejs() {
  if [[ ! -e ${HOME}/.nvm ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  fi
  nvm install --lts
  nvm use --lts
}

setup_clang() {
  sudo apt install clang-format
}

setup_tmux(){
  if [[ ! -e ${HOME}/.tmux ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}


setup_git(){
  if [[ $(type git) ]]; then
    git config --global core.excludesfile ~/.gitignore_global
    git config --global core.editor 'vim -c "set fenc=utf-8"'
  fi
}

install_shellcheck() {
  case "${OSTYPE}" in
    darwin*)
      brew install shellcheck
      ;;
    *)
      export scversion="stable" # or "v0.4.7", or "latest"
      wget "https://storage.googleapis.com/shellcheck/shellcheck-${scversion}.linux.x86_64.tar.xz" -O "./shellcheck-${scversion}.linux.x86_64.tar.xz"
      tar --xz -xvf shellcheck-"${scversion}".linux.x86_64.tar.xz
      mkdir -p ~/.local/bin/ && cp shellcheck-"${scversion}"/shellcheck ~/.local/bin/
      shellcheck --version
      rm -r ./shellcheck*
      ;;
  esac
}

setup_java(){
  curl -s "https://get.sdkman.io" | bash

}

install_tfenv() {
  brew install tfenv
}

install_tools
install_python
install_terraform
install_go
install_nodejs
setup_clang
setup_tmux
setup_git
install_shellcheck
install_tfenv
setup_java

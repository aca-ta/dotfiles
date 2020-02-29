#!/bin/bash

install_tools(){
  case "${OSTYPE}" in
    darwin*)
      brew update
      brew install zsh tmux reattach-to-user-namespace tig bat fzf coreutils gnu-tar
      ;;
    *)
      sudo apt update && sudo apt upgrade
      sudo apt install -u zsh tmux tig fzf
  esac
}

install_python(){
  if [[ ! -e ${HOME}/.pyenv ]]; then
    case "${OSTYPE}" in
      darwin*)
        brew install zlib pyenv
        ;;

      *)
        git clone git://github.com/pyenv/pyenv.git ~/.pyenv
        sudo apt install -y git gcc make openssl libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev zlib1g-dev
    esac
  fi

  CONFIGURE_OPTS="--enable-shared" pyenv install 3.8.2
  pyenv global 3.8.2
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
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
  fi
  nvm install --lts
  nvm use --lts
}

install_youcompleteme(){
  case "${OSTYPE}" in
    darwin*)
      brew install cmake
      ;;

    *)
      sudo apt install -y build-essential cmake python3-dev
  esac
  ~/.vim/plugged/YouCompleteMe/install.py --go-completer --ts-completer --clang-completer
}

setup_tmux(){
  if [[ ! -e ${HOME}/.tmux ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}


setup_git(){
  if [[ $(type git) ]]; then
    git config --global core.excludesfile ~/.gitignore_global
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

install_tools
install_python
install_go
install_nodejs
install_youcompleteme
setup_tmux
setup_git
install_shellcheck

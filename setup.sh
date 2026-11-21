#!/bin/bash

DOTFILES_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tool-versions.sh
source "$DOTFILES_ROOT/tool-versions.sh"
# shellcheck source=scripts/setup-runtimes.sh
source "$DOTFILES_ROOT/scripts/setup-runtimes.sh"

install_tools(){
  case "${OSTYPE}" in
    darwin*)
      brew update
      brew install zsh tmux reattach-to-user-namespace tig bat fzf coreutils gnu-tar fd lsd rg cmake jq macvim neovim jesseduffield/lazygit/lazygit gh ghq terminal-notifier
      ;;
    *)

      # install newer vim
      sudo add-apt-repository ppa:jonathonf/vim

      sudo apt update && sudo apt upgrade
      sudo apt install build-essential make
      brew install zsh tmux tig bat fzf fd lsd gnu-tar gnu-sed ripgrep

      # enable zsh
      command -v zsh | sudo tee -a /etc/shells
      sudo chsh -s "$(command -v zsh)" "${USER}"

      # enable fzf key-bindings
      "$(brew --prefix)/opt/fzf/install"

  esac
}

install_terraform(){
    brew install tfenv terraform-ls
}

setup_clang() {
  case "${OSTYPE}" in
    darwin*) brew install clang-format ;;
    *) sudo apt install clang-format ;;
  esac
}

setup_tmux(){
  if [[ ! -e ${HOME}/.tmux ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}


setup_git(){
  if command -v git >/dev/null 2>&1; then
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

usage() {
  cat <<'HELP'
Usage: ./setup.sh [all|runtimes|python|go|node|--help]
  all       Full setup (default; also changes shell, editor and Git settings)
  runtimes  Update CA bundle and Python, Go, Node.js only
  python    Update CA bundle and the Python/Neovim environment
  go        Update CA bundle and Go
  node      Update CA bundle and nvm/Node.js
HELP
}

main() {
  if (( $# > 1 )); then
    usage >&2
    return 2
  fi
  case "${1:-all}" in
    -h|--help) usage; return ;;
    all|runtimes|python|go|node) ;;
    *) usage >&2; return 2 ;;
  esac
  prepare_runtime_setup
  case "${1:-all}" in
    python) install_python ;;
    go) install_go ;;
    node) install_nodejs ;;
    runtimes) install_python; install_go; install_nodejs ;;
    all)
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
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  set -eo pipefail
  main "$@"
fi

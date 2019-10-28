[[ "$-" != *i* ]] && return

# LANG
export LANG=ja_JP.UTF-8

if [ "$(uname)" = "Darwin" ]; then
  if [ -e "/usr/local/opt/coreutils/libexec/gnubin" ]; then
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    alias ls='gls'
  fi
  if [ -e "/usr/local/opt/coreutils/libexec/gnubin" ]; then
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  fi
else
  export DISPLAY=:0.0
fi

# dircolor
if type dircolors >/dev/null; then
  eval $(dircolors ~/.dircolors.256dark)
fi

## tmux
[ -z "$TMUX" ] && type "tmux" > /dev/null 2>&1 && {
  [ -n "$ATTACH_ONLY" ] && {
    tmux a 2>/dev/null || {
      cd && exec tmux
    }
    exit
  }

  tmux new-window && exec tmux a
  exec tmux
}

## git completion
if [ -f ~/.git-prompt.sh ]; then
  source ~/.git-prompt.sh
  GIT_PS1_SHOWDIRTYSTATE=true
  GIT_PS1_SHOWUPSTREAM=true
  GIT_PS1_SHOWUNTRACKEDFILES=
  GIT_PS1_SHOWSTASHSTATE=true
else
  echo "~/.git-prompt.sh does not exist"
  echo `$HOME`
fi


alias ls='ls --color=auto'
alias ll='ls -l'
alias l='ls '
if [ -f /usr/local/bin/vim ]; then
  alias vim='/usr/local/bin/vim'
fi
alias vi='vim'
alias view='vim -R'
alias exp='explorer.exe'
export TERM=xterm-256color
export PATH="$HOME/.local/bin:$PATH" #XXX

# python
if [ -e ~/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  export PIPENV_VENV_IN_PROJECT=1
  pyenv() {
    unset -f pyenv
    eval "$(pyenv init -)"
    pyenv rehash
    pyenv "$@"
  }
fi

# nvm
if [ -e ~/.nvm/nvm.sh ]; then
  nvm() {
    unset -f nvm
    . ~/.nvm/nvm.sh
    nvm "$@"
  }
fi
#yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# composer
export PATH="$HOME/.composer/vendor/bin:$PATH"

# rbenv
if [ -e ~/.rbenv ];then
  export PATH="$HOME/.rbenv/bin:$PATH"
  rbenv() {
    unset -f rbenv
    eval "$(rbenv init -)"
    rbenv "$@"
  }
fi

# goenv
export GOPATH=$HOME/.go
export PATH="$PATH:$GOPATH/bin"
if [ -e ~/.goenv ]; then
  export GOENV_ROOT=$HOME/.goenv
  export PATH=$GOENV_ROOT/bin:$PATH
  goenv(){
    unset -f goenv
    eval "$(goenv init -)"
    goenv "$@"
  }
fi

# sdkman
if [ -e "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  sdk(){
    unset -f sdk
    . ~/.sdkman/bin/sdkman-init.sh
    sdk "$@"
  }
fi

[[ "$-" != *i* ]] && return

# LANG
export LANG=en_US.UTF-8

# Linuxbrew
if [ -d /home/linuxbrew ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if [ "$(uname)" = "Darwin" ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  if [ -e "/usr/local/opt/coreutils/libexec/gnubin" ]; then
    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    alias ls='gls'
  fi
  if [ -e "/usr/local/opt/gnu-tar/libexec/gnubin/tar" ]; then
    export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
    alias tar='gtar'
  fi
  if [ -e "/usr/local/opt/gnu-sed/libexec/gnubin/sed" ]; then
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    alias sed='gsed'
  fi



elif [[ "$(uname -r)" = *microsoft* ]]; then
    # for VcXsrv
    export DISPLAY=$(ROUTE.EXE print | grep 0.0.0.0 | head -1 | awk '{print $4}'):0.0

    if [ -e "/home/linuxbrew/.linuxbrew/opt/mysql-client/bin" ]; then
      export PATH="/home/linuxbrew/.linuxbrew/opt/mysql-client/bin:$PATH"
    fi
fi

# dircolor
if type dircolors >/dev/null; then
  eval $(dircolors ${HOME}/.dircolors.256dark)
fi

## tmux
[ -z "$TMUX" ] && [ x$TERM_PROGRAM != x"vscode" ] && type "tmux" > /dev/null 2>&1 && {
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
  echo "${HOME}/.git-prompt.sh does not exist"
  echo "${HOME}"
fi

alias gitr='cd $(git rev-parse --show-superproject-working-tree --show-toplevel | head -1)'

alias ls='lsd --color=auto'
alias ll='lsd -l'
alias l='lsd'
if [ -f /usr/local/bin/vim ]; then
  alias vim='/usr/local/bin/vim'
fi
alias vi='nvim'
alias vimdiff='nvim -d'
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
    eval "$(pyenv init --path)"
    pyenv rehash
    pyenv "$@"
  }
fi

# nvm
if [ -e ~/.nvm/nvm.sh ]; then
    source $HOME/.nvm/nvm.sh
    nvm use node
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
if [ -e ~/.goenv ]; then
  export GOENV_ROOT=$HOME/.goenv
  export PATH=$GOENV_ROOT/bin:$PATH
  goenv(){
    unset -f goenv
    eval "$(goenv init -)"
    goenv "$@"
    export PATH="$PATH:$GOENV_ROOT/shims"
  }
fi

# sdkman
if [ -e "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
  export SDKMAN_DIR="$HOME/.sdkman"
  sdk(){
    unset -f sdk
    . $HOME/.sdkman/bin/sdkman-init.sh
    sdk "$@"
  }
fi

# embulk
export PATH="$HOME/.embulk/bin:$PATH"


# fzf
if type fzf-tmux > /dev/null; then

    if type fd > /dev/null; then
        fvi() {
            local key=${1}
            fd $key | fzf-tmux | xargs -o nvim
        }
        fcd() {
            local key=${1}
            fd -a -t d $key | fzf-tmux | read select
            cd $select
            pwd
        }
    fi

    # ghq + fzf-tmux
    if type ghq > /dev/null; then
        gcd() {
            local key=${1}
            ghq list --full-path $key | fzf-tmux --preview "bat --color=always --style=header,grid --line-range :80 {}/README.*" | read select
            cd $select
            pwd
        }
    fi
    # rg + fzf-tmux
    if type rg > /dev/null; then
        rvi() {
            local key=${1}
            rg -l $key | fzf-tmux --preview "rg --color=always $key {}" | xargs -o nvim
        }
    fi
fi

# kubebuilder
export PATH=$PATH:/usr/local/kubebuilder/bin

# rust
export PATH=$PATH:~/.cargo/bin

# mysql
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# psql
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

if [ -e "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# moon
export PATH="$HOME/.moon/bin:$PATH"

# rye
. "$HOME/.rye/env"

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

 export PATH="$PATH:/root/.local/bin"

eval "$(mcfly init bash)"
eval "$(zoxide init bash)"
eval "$(gh completion -s bash)"
eval "$(fzf --bash)"
eval "$(starship init bash)"

export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=2

HISTSIZE=10000
HISTFILESIZE=20000

alias cd='z'
alias vim='nvim'
alias zellij_bash='zellij options --default-shell bash'
alias code='code-server'
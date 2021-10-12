#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export MATPLOTLIBRC="~/.matplotlibrc"

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export LIBVA_DRIVER_NAME="radeonsi"

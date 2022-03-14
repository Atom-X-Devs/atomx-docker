#
# ~/.bashrc
#

# Run .profile
if [ -f ~/.profile ]; then
. ~/.profile
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

PS1='[\u@\h \W]\$ '
#PS1="[\u@\h \w]\\$ \[$(tput sgr0)\]"

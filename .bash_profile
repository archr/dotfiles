#!/usr/bin/env bash

# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Add rvm gems and nginx to the path
export PATH=$PATH:~/.gem/ruby/1.8/bin:/opt/nginx/sbin

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='bakke'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Set my editor and git editor
export EDITOR="/usr/bin/subl -w"
export GIT_EDITOR='/usr/bin/subl -w'

# Set the path nginx
export NGINX_PATH='/opt/nginx'

# Don't check mail when opening terminal.
unset MAILCHECK

export MAMP_PHP=/Applications/MAMP/bin/php/php5.4.19/bin
export PATH="$MAMP_PHP:$PATH"

# export PATH=/usr/local/bin/php:$PATH

# Change this to your console based IRC client of choice.

export IRC_CLIENT='irssi'

# Set this to the command you use for todo.txt-cli

export TODO="t"

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Bash It
source $BASH_IT/bash_it.sh

HISTCONTROL=ignoredups:erasedups
HISTIGNORE='&:ls:z *:g *:clear:c:cl:history:cd ~:cd ..:cd *: ls *:[bf]g:exit:h:history'
shopt -s histappend

HISTSIZE=10000
HISTFILESIZE=5000

alias s='subl .'
alias cl='clear'
alias hg='history | grep '
alias la='ls | grep '
export PATH="$HOME/.deliver/bin:$PATH"

export GOPATH="/Users/antonio/dev/go"
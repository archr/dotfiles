export ZSH=/Users/antonio/.oh-my-zsh

ZSH_THEME="zhann"
CASE_SENSITIVE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(common-aliases history ssh-agent sublime wd react-native history-substring-search npm)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/dev/go
export ANDROID_HOME=/Users/antonio/Library/Android/sdk

export PATH=$PATH:$GOPATH/bin:/Users/antonio/Library/Android/sdk/platform-tools

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='vim'

BASE16_SHELL=~/.config/base16-shell/base16-tomorrow.dark.sh
[[ -s $BASE16_SHELL  ]] && source $BASE16_SHELL

# nvm
export NVM_DIR="/Users/antonio/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# sublime
alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl' 

# yarn
export PATH="$PATH:`yarn global bin`"

# android
export ANDROID_HOME=${HOME}/Library/Android/sdk
export PATH=${PATH}:${ANDROID_HOME}/tools
export PATH=${PATH}:${ANDROID_HOME}/platform-tools

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

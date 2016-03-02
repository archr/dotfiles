export ZSH=/Users/antonio/.oh-my-zsh
ZSH_THEME="kennethreitz"
CASE_SENSITIVE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(common-aliases history ssh-agent sublime wd)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/dev/go
export ANDROID_HOME=/Users/antonio/Library/Android/sdk
export PATH=$PATH:$GOPATH/bin

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
export EDITOR='vim'

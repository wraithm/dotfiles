unset GREP_OPTIONS

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="mygentoo"

# Powerline theme
#ZSH_THEME="agnoster"
#DEFAULT_USER="matt"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git perl history-substring-search battery archlinux ssh-agent cabal mercurial)

#zstyle :omz:plugins:ssh-agent identities id_rsa mwawskey.pem

source $ZSH/oh-my-zsh.sh


# Customize to your needs...

unsetopt correctall
#This is also an option
#alias sudo='nocorrect sudo'

alias ls='ls --color=auto -F'
alias ncmpc='ncmpcpp'
alias scp='noglob scp'
alias pacman='sudo pacman'
alias ghci='stack ghci'
alias systemctl='sudo systemctl'
alias netctl='sudo netctl'
alias netctl-auto='sudo netctl-auto'
alias matlab='matlab -nosplash -nodesktop'
#alias open='evince'
#alias open='apvlv'
alias open='mupdf'
alias pip='sudo pip2'
alias ocaml='rlwrap ocaml "$@"'
#alias cabal='/home/matt/.cabal/bin/cabal'
alias ant='ant -find build.xml'
alias grep='ag'
alias emacs='emacs -nw'
alias updatevim='cd $HOME/.vim/bundle; for file in $(ls); do cd $file; pwd; git pull origin; cd ..; done'
alias ghci-core="ghci -ddump-simpl -dsuppress-idinfo \
    -dsuppress-coercions -dsuppress-type-applications \ 
    -dsuppress-uniques -dsuppress-module-prefixes"
alias gtypist='gtypist -w'

PATH=$PATH:/usr/local/MATLAB/R2011a/bin/:$HOME/.cabal/bin:$HOME/.local/bin:/home/matt/.stack/programs/x86_64-linux/ghc-7.10.3/bin
#PATH=$PATH:$HOME/.cabal/bin
export EDITOR="/usr/bin/vim"
export VISUAL="/usr/bin/vim"
export TZ="America/Chicago"

# OPAM configuration
/home/matt/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
eval `opam config env`

#Syntax highlighting
#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# Autocomplete GHC 7.8 commands
# _ghc()
# {
#     local envs=`ghc --show-options`
#     # get the word currently being completed
#    local cur=${COMP_WORDS[$COMP_CWORD]}
# 
#     # the resulting completions should be put into this array
#     COMPREPLY=( $( compgen -W "$envs" -- $cur ) )
# }
# complete -F _ghc -o default ghc

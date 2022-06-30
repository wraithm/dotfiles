# IF you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="hggentoo"
# ZSH_THEME="gentoo"
# ZSH_THEME="oldgentoo"
# ZSH_THEME="testcrcandy"
ZSH_THEME="newgentoo"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(osx git perl history-substring-search battery cabal stack mercurial brew brew-cask emacs man postgres sudo vagrant aws ssh-agent)
# plugins=(history-substring-search stack man sudo terraform vagrant vault ssh-agent auto-notify)
plugins=(history-substring-search stack man sudo terraform vagrant vault ssh-agent nix-zsh-completions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

unsetopt correctall

# Linux only
alias ls='ls -F --color=auto'
LSCOLORS=exfxcxdxbxegedabagacad;

alias scp='noglob scp'
alias ghci='stack ghci'
alias ocaml='rlwrap ocaml "$@"'
alias ant='ant -find build.xml'
alias emacs='/snap/bin/emacs -nw'
alias ghci-core='stack ghci --ghci-options="-ddump-simpl -dsuppress-idinfo \
    -dsuppress-coercions -dsuppress-type-applications \
    -dsuppress-uniques -dsuppress-module-prefixes"'
alias ec='/snap/bin/emacsclient -ct'
alias ecf='/snap/bin/emacsclient -c -n'
alias vim='/snap/bin/emacsclient -ct -a /usr/bin/vim'
alias vi='/usr/bin/vim'
alias btc='bitcoin-cli -regtest'
alias shake='stack exec shake --'
# Linux only
alias open='xdg-open'

PATH=$HOME/.local/bin:$HOME/.cargo/bin:$PATH
PATH=/usr/lib/postgresql/12/bin:${PATH}
# export EDITOR="/snap/bin/emacsclient -ct -a /usr/bin/vim"
# export EDITOR="/snap/bin/emacs -nw"
export EDITOR=~/.local/bin/editor
export VISUAL=/usr/bin/vim
export PAGER=/usr/bin/less
alias less='/usr/bin/less'

TZ="America/Chicago"

# OPAM configuration
# $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
# eval `opam config env`

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

hash -d btnl=~/src/Bitnomial/bitnomial
hash -d masterbtnl=~/src/Bitnomial/master

export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_SKIP_VERIFY="true"
export VAULT_TOKEN='00000000-0000-0000-0000-000000000000'

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

export VIRTUAL_ENV_DISABLE_PROMPT=1

export REPORTTIME=2

export AUTO_NOTIFY_THRESHOLD=60
export AUTO_NOTIFY_IGNORE=("emacs" "emacsclient" $AUTO_NOTIFY_IGNORE)

# source /home/mwraith/.local/venv/bin/activate

export ANSIBLE_STDOUT_CALLBACK=yaml
export ANSIBLE_FORCE_COLOR=True

eval "$(direnv hook zsh)"

export PATH="$HOME/.gobrew/current/bin:$HOME/.gobrew/bin:$HOME/go/bin:$PATH"

if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    . $HOME/.nix-profile/etc/profile.d/nix.sh
    export LOCALE_ARCHIVE="$(nix-env --installed --no-name --out-path --query glibc-locales)/lib/locale/locale-archive"
    export TERMINFO=$HOME/.nix-profile/share/terminfo
fi

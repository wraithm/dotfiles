autoload -Uz colors && colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{red}*'   # display this when there are unstaged changes
zstyle ':vcs_info:*' stagedstr '%F{yellow}+'  # display this when there are staged changes
zstyle ':vcs_info:*' actionformats '%F{5}(%F{2}%b%F{3}|%F{1}%a%c%u%m%F{5})%f '
zstyle ':vcs_info:*' formats '%F{5}(%F{2}%b%c%u%m%F{5})%f '
zstyle ':vcs_info:svn:*' branchformat '%b'
zstyle ':vcs_info:svn:*' actionformats '%F{5}(%F{2}%b%F{1}:%{3}%i%F{3}|%F{1}%a%c%u%m%F{5})%f '
zstyle ':vcs_info:svn:*' formats '%F{5}(%F{2}%b%F{1}:%F{3}%i%c%u%m%F{5})%f '
zstyle ':vcs_info:*' enable git cvs svn
zstyle ':vcs_info:git*+set-message:*' hooks untracked-git

+vi-untracked-git() {
  if command git status --porcelain 2>/dev/null | command grep -q '??'; then
    hook_com[misc]='%F{red}?'
  else
    hook_com[misc]=''
  fi
}

get_pwd_prompt() {
  local base_prompt_pwd='%(!.%1~.%~)'
  # Regex to remove elements which take no space. Used to calculate the
  # width of the top prompt.
  local zero='%([BSUbfksu]|([FK]|){*})'
  local pwd_expanded=${(S%%)base_prompt_pwd//$~zero/}
  local pwd_len=${#pwd_expanded}
  local vcs_info_len=${#vcs_info_msg_0_}
  local num_cols=$(tput cols)
  if ((pwd_len + 10 > num_cols)); then
    sep_pwd='
'
    prompt_pwd=${pwd_expanded:gs/\//
  \/}
  elif ((pwd_len + vcs_info_len + 10 > num_cols)); then
    sep_pwd='
'
    prompt_pwd=$base_prompt_pwd
  else
    sep_pwd=' '
    prompt_pwd=$base_prompt_pwd
  fi
}

gentoo_precmd() {
  vcs_info
  get_pwd_prompt
}

autoload -U add-zsh-hook
add-zsh-hook precmd gentoo_precmd

sep_big='%-40(l::
)'
sep_small='%-10(l: :
)'

# really simple prompt:
# PROMPT='%F{green}%D{[%H:%M:%S]} %B%F{blue}%(!.%1~.%~) ${vcs_info_msg_0_}%F{red}[%?] %F{blue}%(!.#.$)%k%b%f '

# fancy separated prompt
PROMPT='%F{green}%D{[%H:%M:%S]}%B${sep_small}${vcs_info_msg_0_}%F{red}[%?]${sep_pwd}%F{blue}${prompt_pwd}${sep_pwd}${sep_big}%F{blue}%(!.#.$)%k%b%f '

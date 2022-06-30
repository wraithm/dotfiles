# PROMPT=$'
# %{$fg[red]%}%D{[%H:%M:%S]} %{$reset_color%}%{$fg_bold[blue]%}%~%{$reset_color%} $(git_prompt_info)\
# %{$reset_color%}%{$fg_bold[blue]%}%(!.#.$)%k%b%f%{$reset_color%} '

PROMPT=$'
%{$reset_color%}%{$fg_bold[blue]%}%~%{$reset_color%} $(git_prompt_info)\
%{$reset_color%}%{$fg_bold[blue]%}%(!.#.$)%k%b%f%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

#!/bin/sh

setopt prompt_subst

precmd(){
_gitInfo=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); [ -z $_gitInfo ] && _git_current_branch=" " || _git_current_branch=" %{$fg[blue]%}(%{$fg_bold[green]%}%{$reset_color%} %{$fg[blue]%}$_gitInfo)%{$reset_color%} "

if [[ ${#PWD} -gt 80 ]]; then
PROMPT="
%B%{$fg[white]%}┌── %n%{$fg[cyan]%}@%{$fg[white]%}%m%(?:%{$fg_bold[green]%} ➜ :%{$fg_bold[red]%} ➜ )%{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+='${_git_current_branch}'
PROMPT+="
└─ %(?:%{$fg_bold[green]%}  :%{$fg_bold[red]%}  )"
else
PROMPT="
%B%{$fg[white]%}%n%{$fg[cyan]%}@%{$fg[white]%}%m%(?:%{$fg_bold[green]%} ➜ :%{$fg_bold[red]%} ➜ )%{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+='${_git_current_branch}'
PROMPT+="%(?:%{$fg_bold[green]%} :%{$fg_bold[red]%} )"
fi
}

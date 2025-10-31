#!/bin/bash

setopt prompt_subst

git_prompt_info() {
  # Check if in a Git repo
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    local branch_name

    # Check if detached HEAD
    if ! branch_name=$(git symbolic-ref -q --short HEAD 2>/dev/null); then
      # Handle detached HEAD (show commit hash or tag)
      local commit_hash
      commit_hash=$(git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
      echo "HEAD detached at ${commit_hash}"
    else
      # Check if branch tracks a remote
      local upstream
      upstream=$(git config --get branch."${branch_name}".remote 2>/dev/null)
      if [ -n "$upstream" ]; then
        # Show tracking info (e.g., "main → origin/main")
        local remote_branch
        remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
        # echo "${branch_name} → ${remote_branch}"
        echo "${remote_branch}"
      else
        # Local branch (no tracking)
        echo "untracked/${branch_name}"
      fi
    fi
  fi
}


precmd(){
_gitInfo=$(git_prompt_info); [ -z $_gitInfo ] && _git_current_branch=" " || _git_current_branch=" %{$fg[blue]%}(%{$fg_bold[green]%}%{$reset_color%} %{$fg[blue]%}$_gitInfo)%{$reset_color%} "
# _venvInfo=$([ $VIRTUAL_ENV ] && basename $VIRTUAL_ENV); [ -z $_venvInfo ] && _venv="" || _venv="%{$fg[blue]%}[ $_venvInfo] %{$reset_color%}"
_venvInfo=$([ $VIRTUAL_ENV ] && basename $VIRTUAL_ENV); [ -z $_venvInfo ] && _venv="" || _venv="%{$fg[blue]%}[ venv] %{$reset_color%}"

# if the space to write our command is less than 150 character long
if [[ ${#PWD} - ${#USER} - ${#HOST} -gt 50 ]]; then
PROMPT="
"
PROMPT+="${_venv}"
PROMPT+="%B%{$fg[white]%}%n%{$fg[cyan]%}@%{$fg[white]%}%m  %(?:%{$fg_bold[green]%}"
PROMPT+=" ➜ :%{$fg_bold[red]%} ➜ )%{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+='${_git_current_branch}'
PROMPT+="
└─ %(?:%{$fg_bold[green]%} %{$reset_color%}:%{$fg_bold[red]%} %{$reset_color%})"
else
PROMPT="
"
PROMPT+="${_venv}"
PROMPT+="%B%{$fg[white]%}%n%{$fg[cyan]%}@%{$fg[white]%}%m  %(?:%{$fg_bold[green]%}"
PROMPT+=" ➜ :%{$fg_bold[red]%} ➜ )%{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+='${_git_current_branch}'
PROMPT+="%(?:%{$fg_bold[green]%} %{$reset_color%}:%{$fg_bold[red]%} %{$reset_color%})"
fi
}

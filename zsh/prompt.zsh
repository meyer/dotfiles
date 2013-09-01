autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

ruby_version() {
  if (( $+commands[rbenv] ))
  then
    echo "$(rbenv version | awk '{print $1}')"
  fi

  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}')"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
    echo "%{$fg_bold[yellow]%}$(ruby_version)%{$reset_color%} "
  else
    echo ""
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

function virtualenv_prompt_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        if [ -f "$VIRTUAL_ENV/__name__" ]; then
            local name=`cat $VIRTUAL_ENV/__name__`
        elif [ `basename $VIRTUAL_ENV` = "__" ]; then
            local name=$(basename $(dirname $VIRTUAL_ENV))
        else
            local name=$(basename $VIRTUAL_ENV)
        fi
        echo "%{$fg_bold[yellow]%}[$name]%{$reset_color%} "
    fi
}

# Holman ZSH theme

# export PROMPT=$'\n$(directory_name) $(git_dirty)$(need_push)\n$(virtualenv_prompt_info)$ '
# set_prompt () {
#   export RPROMPT="%{$fg_bold[cyan]%}%T%{$reset_color%}"
# }
#
# precmd() {
#   title "zsh" "%m" "%55<...<%~"
#   set_prompt
# }


# My barely customised theme from OMZ

# PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c $(virtualenv_prompt_info)%{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

# ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"




# Modified sorin theme

# Load dependencies.
# pmodload 'helper'

setopt localoptions extendedglob

function prompt_meyer_pwd {
  local pwd="${PWD/#$HOME/~}"
  # TODO: Make this less unintelligble.
  if [[ "$pwd" == (#m)[/~] ]]; then
    _prompt_meyer_pwd="$MATCH"
    unset MATCH
  else
    _prompt_meyer_pwd="${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}/${pwd:t}"
  fi
}

function prompt_meyer_precmd {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS

  # Format PWD.
  prompt_meyer_pwd

  # Get Git repository information.
  if (( $+functions[git-info] )); then
    git-info
  fi
}

function prompt_meyer_setup {
  setopt LOCAL_OPTIONS
  unsetopt XTRACE KSH_ARRAYS
  prompt_opts=(cr percent subst)

  # Load required functions.
  autoload -Uz add-zsh-hook

  # Add hook for calling git-info before each command.
  add-zsh-hook precmd prompt_meyer_precmd

  # Set editor-info parameters.
  zstyle ':prezto:module:editor:info:completing' format '%B%F{red}...%f%b'
  zstyle ':prezto:module:editor:info:keymap:primary' format ' %B%F{red}❯%F{yellow}❯%F{green}❯%f%b'
  zstyle ':prezto:module:editor:info:keymap:primary:overwrite' format ' %F{red}♺%f'
  zstyle ':prezto:module:editor:info:keymap:alternate' format ' %B%F{green}❮%F{yellow}❮%F{red}❮%f%b'

  # Set git-info parameters.
  zstyle ':prezto:module:git:info' verbose 'yes'
  zstyle ':prezto:module:git:info:action' format ':%%B%F{yellow}%s%f%%b'
  zstyle ':prezto:module:git:info:added' format ' %%B%F{green}✚%f%%b'
  zstyle ':prezto:module:git:info:ahead' format ' %%B%F{yellow}⬆%f%%b'
  zstyle ':prezto:module:git:info:behind' format ' %%B%F{yellow}⬇%f%%b'
  zstyle ':prezto:module:git:info:branch' format ':%F{green}%b%f'
  zstyle ':prezto:module:git:info:commit' format ':%F{green}%.7c%f'
  zstyle ':prezto:module:git:info:deleted' format ' %%B%F{red}✖%f%%b'
  zstyle ':prezto:module:git:info:modified' format ' %%B%F{blue}✱%f%%b'
  zstyle ':prezto:module:git:info:position' format ':%F{red}%p%f'
  zstyle ':prezto:module:git:info:renamed' format ' %%B%F{magenta}➜%f%%b'
  zstyle ':prezto:module:git:info:stashed' format ' %%B%F{cyan}✭%f%%b'
  zstyle ':prezto:module:git:info:unmerged' format ' %%B%F{yellow}═%f%%b'
  zstyle ':prezto:module:git:info:untracked' format ' %%B%F{white}◼%f%%b'
  zstyle ':prezto:module:git:info:keys' format \
    'prompt' '%F{blue}git%f$(coalesce "%b" "%p" "%c")%s' \
    'rprompt' '%A%B%S%a%d%m%r%U%u'

  # Define prompts.
  PROMPT='${git_info:+${(e)git_info[prompt]}}%(!. %B%F{red}#%f%b.) $(virtualenv_prompt_info)%F{cyan}${_prompt_meyer_pwd}%f${editor_info[keymap]} '
  RPROMPT='${editor_info[overwrite]}%(?:: %F{red}⏎%f)${VIM:+" %B%F{green}V%f%b"}${git_info[rprompt]}'
  SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
}

prompt_meyer_setup "$@"
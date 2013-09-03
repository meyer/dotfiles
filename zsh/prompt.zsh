autoload colors && colors
setopt localoptions extendedglob
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
			echo " on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
		else
			echo " on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
		fi
	fi
}

git_prompt_info () {
	ref=$($git symbolic-ref HEAD 2>/dev/null) || return
	echo "${ref#refs/heads/}"
}

unpushed () {
	$git cherry -v @{upstream} 2>/dev/null
}

need_push () {
	if [[ $(unpushed) == "" ]]
	then
		echo ""
	else
		echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%}"
	fi
}

ruby_version() {
	echo "$(rbenv version | awk '{print $1}')"
}

python_version() {
	echo "$(pyenv version | awk '{print $1}')"
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
		echo "%{$fg_bold[white]%}[$name]%{$reset_color%} " #"/$(python_version) "
	fi
}

function prompt_meyer_pwd {
	local pwd="${PWD/#$HOME/~}"
	if [[ "$pwd" == (#m)[/~] ]]; then
		_prompt_meyer_pwd="$MATCH"
		unset MATCH
	else
		# TODO: Make this less unintelligble.
		_prompt_meyer_pwd="${${${(@j:/:M)${(@s:/:)pwd}##.#?}:h}%/}/${pwd:t}"
	fi
}

function prompt_meyer_precmd {
	setopt LOCAL_OPTIONS
	unsetopt XTRACE KSH_ARRAYS

	# Format PWD.
	prompt_meyer_pwd

	# Get Git repository information.
	#if (( $+functions[git-info] )); then git-info; fi
}

function old_prompt_meyer_setup {
	setopt LOCAL_OPTIONS
	unsetopt XTRACE KSH_ARRAYS
	prompt_opts=(cr percent subst)

	# Load required functions.
	autoload -Uz add-zsh-hook

	# Add hook for calling git-info before each command.
	add-zsh-hook precmd prompt_meyer_precmd

	# Set editor-info parameters.
	zstyle ':prezto:module:editor:info:completing' format '%B%F{red}…%f%b'
	zstyle ':prezto:module:editor:info:keymap:primary' format ' %B%F{red}❯%F{yellow}❯%F{green}❯%f%b'
	zstyle ':prezto:module:editor:info:keymap:primary:overwrite' format ' %F{red}♺%f'
	zstyle ':prezto:module:editor:info:keymap:alternate' format ' %B%F{green}❮%F{yellow}❮%F{red}❮%f%b'

	# Define prompts.
	PROMPT=''
	# PROMPT+='${git_info:+${(e)git_info[prompt]}}'
	PROMPT+='$(git_prompt_info)'
	PROMPT+='%(!. %B%F{red}#%f%b.) '
	PROMPT+='$(virtualenv_prompt_info)'
	PROMPT+='%F{cyan}${_prompt_meyer_pwd}%f'
	PROMPT+='${editor_info[keymap]} '
	# RPROMPT='${editor_info[overwrite]}%(?:: %F{red}⏎%f)${VIM:+" %B%F{green}V%f%b"}${git_info[rprompt]}'
	RPROMPT=''
	SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '
}

function prompt_meyer_setup {
	setopt LOCAL_OPTIONS
	unsetopt XTRACE KSH_ARRAYS
	prompt_opts=(cr percent subst)

	add-zsh-hook precmd prompt_meyer_precmd

	# Set editor-info parameters.
	zstyle ':prezto:module:editor:info:completing' format '%B%F{red}…%f%b'
	zstyle ':prezto:module:editor:info:keymap:primary' format '%B%F{red}❯%F{yellow}❯%F{green}❯%f%b'
	zstyle ':prezto:module:editor:info:keymap:primary:overwrite' format ' %F{red}♺%f'
	zstyle ':prezto:module:editor:info:keymap:alternate' format ' %B%F{green}❮%F{yellow}❮%F{red}❮%f%b'

	PROMPT=''
	# PROMPT+='%{$fg_bold[red]%}➜ '
	# PROMPT+='%{$fg_bold[green]%}%p '
	PROMPT+='%{$fg[cyan]%}${_prompt_meyer_pwd}'
	PROMPT+='$(virtualenv_prompt_info)'
	PROMPT+='%{$fg_bold[blue]%}$(git_dirty)'
	PROMPT+='$(need_push)'
	PROMPT+='%{$fg_bold[blue]%} % %{$reset_color%}'
	PROMPT+='${editor_info[keymap]} '

	RPROMPT="%{$fg_bold[cyan]%}%T%{$reset_color%}"

	ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
	ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
}

prompt_meyer_setup "$@"
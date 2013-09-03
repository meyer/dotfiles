setopt localoptions extendedglob

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
			echo ' on %B%F{green}$(git_prompt_info)%f%b'
		else
			echo " on %B%F{red}$(git_prompt_info)%f%b"
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
		echo ''
	else
		echo ' with %B%F{magenta}unpushed%f%b'
	fi
}

ruby_version() {
	echo "$(rbenv version | awk '{print $1}')"
}

python_version() {
	echo "$(pyenv version | awk '{print $1}')"
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
	setopt localoptions
	unsetopt xtrace ksharrays
	prompt_meyer_pwd
}

function prompt_meyer_setup {
	unsetopt xtrace ksharrays
	prompt_opts=(cr percent subst)

	add-zsh-hook precmd prompt_meyer_precmd

	zstyle ':prezto:module:editor:info:completing' format '%B%F{red}…%f%b'

	# cool arrow: ➜
	PROMPT=''
	# PROMPT+=$'\n'
	PROMPT+='%B%F{cyan}${_prompt_meyer_pwd}%f%b'
	PROMPT+='%F{green}$(virtualenv_prompt_info)%f'
	PROMPT+='%F{blue}$(git_dirty)%f'
	PROMPT+='%F{red}$(need_push)%f'
	# PROMPT+='%F{green}$(python_version)%f'
	# PROMPT+=$'\n'
	PROMPT+=$' '
	PROMPT+='%F{green}❯%f '
}

prompt_meyer_setup "$@"
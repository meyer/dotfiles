set __fish_git_prompt_showcolorhints "yep"
set __fish_git_prompt_showdirtystate "yep"

function fish_prompt
	# set_color $fish_color_cwd
	set_color cyan
	echo -n (prompt_pwd)
	set_color normal
	echo -n (__fish_git_prompt)
	set_color green
	echo -n " ❯ "
	set_color normal
end
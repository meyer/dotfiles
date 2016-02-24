set -g __fish_git_prompt_showcolorhints 'yep'
set -g __fish_git_prompt_showdirtystate 'yep'
set -g __fish_git_prompt_showupstream 'auto'
set -g __fish_git_prompt_show_informative_status 'why not'
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_prompt_hostname (hostname|cut -d . -f 1)

function fish_prompt
  # set_color $fish_color_cwd
    set_color -b purple
    set_color -o white
    echo -n " "
    echo -n $__fish_prompt_hostname | tr '[a-z]' '[A-Z]'
    echo -n " "
    # echo -n \U1F4BB
    set_color normal
    echo -n " "
  set_color cyan
  echo -n (prompt_pwd)
  set_color normal
  echo -n (__fish_git_prompt)
  set_color green
  echo -n " ❯ "
  set_color normal
end

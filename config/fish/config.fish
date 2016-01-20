set --erase fish_greeting
set PATH "/usr/local/share/npm/bin" $PATH
set PATH "$HOME/Repositories/chromium-depot-tools" $PATH
set PATH "/Applications/Postgres93.app/Contents/MacOS/bin" $PATH
set PATH "/Applications/VirtualBox.app/Contents/MacOS" $PATH
set PATH "$HOME/.pyenv/bin" $PATH
set PATH "$HOME/.rbenv/bin" $PATH
set PATH "$HOME/Development/android-sdk-macosx/platform-tools" $PATH
set PATH "$HOME/Development/arcanist/bin" $PATH
set PATH "$HOME/Repositories/authbox/ops/bin" $PATH
set PATH "$HOME/bin" $PATH
set EDITOR "mate -w"

set fish_color_autosuggestion "555"
set fish_color_command "af87ff"
set fish_color_comment "8a8a8a"
set fish_color_end "ffff5f"
set fish_color_error "ff5f5f"
set fish_color_host "\x2do\x1ecyan"
set fish_color_param "00afff"
set fish_color_quote "ffaf00"
set fish_color_redirection "00ffaf"
set fish_color_status "red"
set fish_color_user "\x2do\x1egreen"

# complete -c itermocil -a "(itermocil --list)"

# perl to the rescue
set -lx _fish_file ~/.config/fish/(echo (eval hostname) | perl -ne 's/.local$//; s/\W+/-/; print lc($_)').fish

function git
  hub $argv
end

function serve
  python -m SimpleHTTPServer $argv
end

if test -f $_fish_file
  source $_fish_file
end

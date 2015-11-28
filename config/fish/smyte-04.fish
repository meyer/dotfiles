set -g FABDIR '/Users/meyer/Repositories/authbox/apps/fab'
set -g AUTHBOX_API_DIR '~/Repositories/authbox/authbox-api'

function aa; pushd $AUTHBOX_API_DIR; end
function cdfab; pushd $FABDIR; end

function rainbow
    echo $argv | toilet --gay -f term -F border --gay
end

# Git/Phabricator
function gdf
    rainbow "***** Files *****"
    git diff --stat --cached origin/master
end

function gd
    gdf
    rainbow "***** Code *****"
    git diff origin/master
end

# Phabricator
alias preview='arc diff --preview'
alias update='arc diff --update'

function resync
    git fetch origin
    git rebase origin/master
    git submodule update
end

function l
    pushd $AUTHBOX_API_DIR
    rainbow "***** Running lint in "(echo $AUTHBOX_API_DIR)" *****"
    jsxhint .
    popd
end

function bt
    pushd $AUTHBOX_API_DIR
    node --harmony test.js
    popd
end

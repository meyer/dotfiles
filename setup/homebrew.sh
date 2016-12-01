#!/usr/bin/env bash

# Make sure Homebrew is installed.
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install fish boxes toilet hub grc git gist lzo jpeg node python ruby

# Install fisherman + plugins
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
fisher up

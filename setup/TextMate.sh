#!/usr/bin/env bash

mkdir -p ~/Library/Application\ Support/Avian/Bundles

ln -s $HOME/Repositories/Whitespace-tmbundle $HOME/Library/Application\ Support/Avian/Bundles/Whitespace.tmbundle
ln -s $HOME/Repositories/Meyer-tmbundle $HOME/Library/Application\ Support/Avian/Bundles/Meyer.tmbundle

defaults write com.macromates.TextMate.preview findInSelectionByDefault -bool YES
defaults write com.macromates.TextMate.preview fontSmoothing 0
defaults write com.macromates.TextMate.preview fileBrowserPlacement left
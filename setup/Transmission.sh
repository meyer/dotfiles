#!/usr/bin/env bash

mkdir -p $HOME/Torrents/{Complete,Incomplete}

defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Torrents/Incomplete"
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Torrents/Complete";
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

defaults write org.m0k.transmission WarningDonate -bool false
defaults write org.m0k.transmission WarningLegal -bool false
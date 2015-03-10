#!/usr/bin/env bash

# Install Developer Environment with homebrew

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# GNU core utilities for the benefit of dired
brew install coreutils
brew install git

brew install emacs --HEAD --cocoa

brew install caskroom/cask/brew-cask
brew cask install dropbox
brew cask install 1password
brew cask install google-chrome
brew cask install virtualbox
brew cask install vagrant

brew linkapps
brew cleanup

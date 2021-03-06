#!/bin/bash

ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"

if [ $? -eq 0 ]; then

	# Make sure we’re using the latest Homebrew
	brew update

	# Upgrade any already-installed formulae
	brew upgrade

	brew install bash-completion git

	# Install GNU core utilities (those that come with OS X are outdated)
	# brew install coreutils
	# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
	# brew install findutils
	# Install Bash 4
	# brew install bash
	# Install wget
	brew install wget

	# Remove outdated versions from the cellar
	brew cleanup

	# cd
	# git clone git://github.com/sstephenson/rbenv.git .rbenv
	# mkdir -p ~/.rbenv/plugins
	# cd ~/.rbenv/plugins
	# git clone git://github.com/sstephenson/ruby-build.git
	# export PATH="$HOME/.rbenv/bin:$PATH"
	# rbenv rehash
	# rbenv install 1.9.3-p194
	# rbenv rehash
	# rbenv global 1.9.3-p194

fi

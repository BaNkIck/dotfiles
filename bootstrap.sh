#!/bin/bash

# cd to the script directory
cd "$(dirname "$0")"

# get `dotfiles` last version
git pull

function doIt() {

    # Install PHP 5.4
    if [ ! -e /usr/local/php5 ]; then
        read -p "Install PHP 5.4? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            curl -s http://php-osx.liip.ch/install.sh | bash -s 5.4
        fi
    fi

    # Install Composer
    if [ ! -e /usr/local/bin/composer ]; then
        read -p "Install Composer? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            source software/composer.sh
        fi
    fi

    # Install MacPorts
    if [ ! -e /opt/local/bin/port ]; then
        read -p "Install MacPorts? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            source software/macports.sh
        fi
    fi

    # Install Homebrew
    if [ ! -e /usr/local/bin/brew ]; then
        read -p "Install Homebrew? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            source software/homebrew.sh
        fi
    fi

    # Install Sublime Text 2
    if [ ! -e "/Applications/Sublime Text 2.app" ]; then
        read -p "Install Sublime Text 2? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            source software/sublimetext2-dev.sh
        fi
    fi

    # Copy all files to home directory
    rsync --exclude ".git/" --exclude ".DS_Store" --exclude ".gitconfig" --exclude "bootstrap.sh" --exclude "README.md" --exclude "init" --exclude "data" --exclude "software" -av . ~

    # Hanlde .extra file
    if [ -f ~/.extra ]; then
        echo "These changes have been made in the .extra.dist file, please handle these manually"
        diff .extra.dist ~/.extra
    else
        mv ~/.extra.dist ~/.extra
    fi

    # Handle .gitconfig file
    if [ -f ~/.gitconfig ] && ! grep -q "\!\!\! dotfiles .gitconfig included \!\!\!" ~/.gitconfig; then
        cat .gitconfig > ~/.gitconfig_tmp
        if [ -f ~/.gitconfig ]; then
            cat ~/.gitconfig >> ~/.gitconfig_tmp
        fi
        mv ~/.gitconfig_tmp ~/.gitconfig
    elif [ ! -f ~/.gitconfig ]; then
        cp .gitconfig ~/.gitconfig
    fi

    # Create .vim structure for backups, undo history and swap files
    for fldr in backups swaps undo; do
        if [ ! -d ~/.vim/$fldr ]; then
            mkdir -p ~/.vim/$fldr
        fi
    done

    # Handle Sublime Text 2 Packages
    ST_LB_PACKAGES=~/Library/Application\ Support/Sublime\ Text\ 2/Packages
    ST_DB_PACKAGES=~/Dropbox/Sublime\ Text\ 2/Packages
    if [ -d "$ST_DB_PACKAGES" ]; then
        if [ ! -L "$ST_LB_PACKAGES" ]; then
            mv "$ST_LB_PACKAGES" "$ST_LB_PACKAGES""_old"
        fi
        if [ ! -e "$ST_LB_PACKAGES" ]; then
            ln -s "$ST_DB_PACKAGES" "$ST_LB_PACKAGES"
        fi
    fi
}


if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi

unset doIt

# load all changes
source ~/.bash_profile

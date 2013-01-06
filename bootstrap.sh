#!/bin/bash
cd "$(dirname "$0")"
git pull
function doIt() {
    if [ ! -e /usr/local/php5 ]; then
        read -p "Install PHP 5.4? (y/n) " -n 1
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            curl -s http://php-osx.liip.ch/install.sh | bash -s 5.4
        fi
    fi
    rsync --exclude ".git/" --exclude ".DS_Store" --exclude ".gitconfig" --exclude "bootstrap.sh" --exclude "README.md" --exclude "init" --exclude "data" --exclude "software" -av . ~
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
    # if [ -d ~/Library ]; then
    #     if [ ! -d ~/Library/Application\ Support/Sublime\ Text\ 2/Installed\ Packages-old ]; then
    #         mv ~/Library/Application\ Support/Sublime\ Text\ 2/Installed\ Packages ~/Library/Application\ Support/Sublime\ Text\ 2/Installed\ Packages-old
    #         mv ~/Library/Application\ Support/Sublime\ Text\ 2/Packages ~/Library/Application\ Support/Sublime\ Text\ 2/Packages-old
    #         mv ~/Library/Application\ Support/Sublime\ Text\ 2/Pristine\ Packages ~/Library/Application\ Support/Sublime\ Text\ 2/Pristine\ Packages-old
    #         ln -sf `pwd`/Sublime\ Text\ 2/Installed\ Packages ~/Library/Application\ Support/Sublime\ Text\ 2/Installed\ Packages
    #         ln -sf `pwd`/Sublime\ Text\ 2/Packages ~/Library/Application\ Support/Sublime\ Text\ 2/Packages
    #         ln -sf `pwd`/Sublime\ Text\ 2/Pristine\ Packages ~/Library/Application\ Support/Sublime\ Text\ 2/Pristine\ Packages
    #     fi
    # fi
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
source ~/.bash_profile

#!/bin/bash

function installMacPorts() {
	URL=`curl -s http://www.macports.org/install.php | grep -Eo "<a [^>]*>tar\.gz</a>" | sed -E "s/<a [^>]*href=['\"]([^'\"]+)['\"][^>]*>tar\.gz<\/a>/\1/" | sed 's/ /%20/g'`
	DOWNLOAD_DIR="/tmp/macports-$$"
	FILE="${URL##http*/}"
	mkdir -p "$DOWNLOAD_DIR"
	cd "$DOWNLOAD_DIR"
	sudo -v
	curl -O "$URL" && tar xzf "$FILE" && cd "${FILE%.tar.gz}" && ./configure && make && sudo make install
	rm -rf "$DOWNLOAD_DIR"
	sudo /opt/local/bin/port -v selfupdate
}

if [ ! -e "/opt/local/bin/port" ]; then
	installMacPorts
else
	echo "MacPorts already installed. Nothing changed."
fi

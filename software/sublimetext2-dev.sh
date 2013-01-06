#!/bin/bash

function installSublime() {
	URL=`curl -s http://www.sublimetext.com/dev | grep -Eo "<a [^>]*>OS X</a>" | sed -E "s/<a [^>]*href=['\"]([^'\"]+)['\"][^>]*>OS X<\/a>/\1/" | sed 's/ /%20/g'`
	DOWNLOAD_DIR="/tmp/sublimetext2-dev-$$"
	FILE="${URL##http*/}"
	mkdir -p "$DOWNLOAD_DIR"
	cd "$DOWNLOAD_DIR"
	VOLUME_PATH=$(curl -sO $URL && hdiutil attach "$FILE" -nobrowse | grep "/Volumes/" | sed -E "s/^.+(\/Volumes\/.+)$/\1/")
	if [ $? -eq 0 ]; then
		cp -R "$VOLUME_PATH/Sublime Text 2.app" .
		hdiutil detach "$VOLUME_PATH" -force -quiet
	fi
	rm -rf "$DOWNLOAD_DIR"
}

if [ ! -d "/Applications/Sublime Text 2.app" ]; then
	installSublime
else
	echo "Sublime Text 2 already installed. Nothing changed."
fi

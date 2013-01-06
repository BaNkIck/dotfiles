#!/bin/bash
url="https://iterm2.googlecode.com/files/iTerm2_v1_0_0.zip"
zip="${url##http*/}"
download_dir="/tmp/iterm2-$$"
mkdir -p "$download_dir"
curl -L "$url" -o "${download_dir}/${zip}"
unzip -q "${download_dir}/${zip}" -d /Applications/
rm -rf "$download_dir"
echo "iTem 2 installed"

#!/bin/bash
function installComposer() {
	cwd=`pwd`
	tmp_dir="/tmp/composer-$$"
	mkdir -p $tmp_dir
	cd $tmp_dir
	curl -s http://getcomposer.org/installer | php
	sudo mv composer.phar /usr/local/bin/composer
	cd $cwd
	rm -rf $tmp_dir
}
if [ ! -e /usr/local/bin/composer ]; then
	installComposer
fi

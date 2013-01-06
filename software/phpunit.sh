#!/bin/bash
if [ -e /usr/local/php5/bin/pear ]; then
	sudo /usr/local/php5/bin/pear config-set auto_discover 1
	sudo /usr/local/php5/bin/pear install pear.phpunit.de/PHPUnit
else
	echo "pear not found. Composer could not be installed"
fi

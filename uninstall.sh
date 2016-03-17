#!/bin/sh

if [ -h /usr/local/bin/add-intermediate-ca ]; then
	rm -f /usr/local/bin/add-intermediate-ca
fi

if grep -q /opt/farm/ext/imap-server/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/imap-server\/cron/d" /etc/crontab
fi

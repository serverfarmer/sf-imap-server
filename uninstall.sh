#!/bin/sh

if grep -q /opt/farm/ext/imap-server/cron /etc/crontab; then
	sed -i -e "/\/opt\/farm\/ext\/imap-server\/cron/d" /etc/crontab
fi

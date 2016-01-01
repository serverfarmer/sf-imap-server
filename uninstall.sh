#!/bin/sh

if [ -h /usr/local/bin/add-imap-user ]; then
	rm -f /usr/local/bin/add-imap-user
fi

if [ -h /usr/local/bin/add-intermediate-ca ]; then
	rm -f /usr/local/bin/add-intermediate-ca
fi

if grep -q /opt/sf-imap-server/cron /etc/crontab; then
	sed -i -e "/\/opt\/sf-imap-server\/cron/d" /etc/crontab
fi

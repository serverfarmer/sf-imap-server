#!/bin/bash
. /opt/farm/scripts/init
. /opt/farm/scripts/functions.install



set_courier_option() {
	file=$1
	key=$2
	value=$3

	if ! grep -q ^$key $file; then
		echo >>$file
		echo "$key=$value" >>$file
	else
		sed -i -e "s/^\($key\)=.*/\\1=$value/" $file
	fi
}


if [ "$OSVER" != "debian-squeeze" ] && [ "$OSVER" != "debian-wheezy" ] && [ "$OSVER" != "debian-jessie" ] && [ "$OSVER" != "ubuntu-trusty" ] && [ "$OSVER" != "ubuntu-xenial" ]; then
	echo "skipping courier imap setup, unsupported operating system version"
	exit 1
fi

/opt/farm/scripts/setup/extension.sh sf-php
/opt/farm/ext/farm-roles/install.sh imap

/etc/init.d/courier-imap-ssl stop
/etc/init.d/courier-imap stop
/etc/init.d/courier-authdaemon stop

if [ "$HWTYPE" != "container" ] && [ "$HWTYPE" != "lxc" ]; then
	update-rc.d -f courier-imap-ssl remove
	update-rc.d -f courier-imap remove
	update-rc.d -f courier-authdaemon remove
fi

save_original_config /etc/courier/imapd
save_original_config /etc/courier/imapd-ssl

set_courier_option /etc/courier/imapd IMAP_CHECK_ALL_FOLDERS 1
set_courier_option /etc/courier/imapd-ssl SSLADDRESS 0.0.0.0

mkdir -p /srv/imap /usr/local/share/ca-certificates/courier

if [ "$OSVER" = "debian-jessie" ] && [ ! -f /etc/courier/dhparams.orig ]; then
	mv /etc/courier/dhparams.pem /etc/courier/dhparams.orig
	openssl dhparam -out /etc/courier/dhparams.pem 2048
fi

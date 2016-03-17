#!/bin/sh

user=$1
mode=$2
home="`sh -c \"echo ~$user\"`"

if [ ! -d $home/Maildir ]; then
	exit 0
fi

# TODO: implement separate log directories for each year/month
log="$home/logs/$mode-`date +%Y%m%d-%H%M`.$$.log"

LANG=en_US.UTF-8 fetchmail -f $home/.fetchmailrc --mda "/usr/bin/maildrop -d $user" >$log 2>&1

/opt/farm/ext/imap-server/cron/notify.sh $log $home $mode

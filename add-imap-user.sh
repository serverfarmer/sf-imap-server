#!/bin/bash
. /opt/farm/scripts/functions.uid
. /opt/farm/scripts/functions.custom
# create IMAP/fetchmail account, first on local backup/management server,
# then on specified mail server
# Tomasz Klim, 2014-2016


MINUID=1400
MAXUID=1599


if [ "$2" = "" ]; then
	echo "usage: $0 <user> <remote-server[:port]>"
	exit 1
elif ! [[ $1 =~ ^[a-z0-9]+$ ]]; then
	echo "error: parameter 1 not conforming user name format"
	exit 1
elif ! [[ $2 =~ ^[a-z0-9.-]+[.][a-z0-9]+([:][0-9]+)?$ ]]; then
	echo "error: parameter 2 not conforming host name format"
	exit 1
elif [ -d /srv/imap/$1 ]; then
	echo "error: user $1 exists"
	exit 1
elif [ "`getent hosts $2`" = "" ]; then
	echo "error: host $2 not found"
	exit 1
fi

uid=`get_free_uid $MINUID $MAXUID`

if [ $uid -lt 0 ]; then
	echo "error: no free UIDs"
	exit 1
fi

path=/srv/imap/$1

useradd -u $uid -d $path -m -g imapusers -s /bin/false imap-$1
chmod 0711 $path
date +"%Y.%m.%d %H:%M" >$path/from.date

touch $path/.fetchmailrc
touch $path/.ignorepatterns
touch $path/.uidl

mkdir -p $path/Maildir/cur $path/Maildir/new $path/Maildir/tmp $path/logs

chmod -R 0700 $path/Maildir
chmod 0750 $path/logs
chmod 0660 $path/.ignorepatterns
chmod 0600 $path/.fetchmailrc $path/.uidl

rm $path/.bash_logout $path/.bashrc $path/.profile
chown -R imap-$1:imapusers $path

server=$2
if [ -z "${server##*:*}" ]; then
	host="${server%:*}"
	port="${server##*:}"
else
	host=$server
	port=22
fi

sshkey=`ssh_management_key_storage_filename $host`

rsync -e "ssh -i $sshkey -p $port" -av $path root@$host:/srv/imap

ssh -i $sshkey -p $port root@$host "useradd -u $uid -d $path -M -g imapusers -s /bin/false imap-$1"
ssh -i $sshkey -p $port root@$host "usermod -G www-data -a imap-$1"
ssh -i $sshkey -p $port root@$host "echo \"# */5 * * * * imap-$1 /opt/sf-imap-server/cron/fetchmail.sh imap-$1 $1\" >>/etc/crontab"
ssh -i $sshkey -p $port root@$host "passwd imap-$1"

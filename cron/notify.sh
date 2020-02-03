#!/bin/sh

rcpt="fetchmail@`/opt/farm/config/get-external-domain.sh`"

log=$1
home=$2
mode=$3

if [ "$4" != "" ]; then
	rcpt="$4"
fi

cat $log |grep -v ^$ |grep -vf $home/.ignorepatterns |egrep -v "^[0-9]+ message[s]? (\([0-9]+ seen\) )?for .* at .* \([0-9-]+ octets\)" >$log.tmp

if [ -s $log.tmp ]; then
	subject="fetchmail $mode z dnia `date +%Y-%m-%d.%H:%M`"
	for addr in $rcpt; do
		cat $log.tmp |mail -s "$subject" $addr
	done
fi

rm -f $log.tmp
bzip2 -9 $log

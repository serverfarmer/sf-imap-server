#!/bin/bash
# register intermediate CA SSL certificate
# Tomasz Klim, 2015


if [ "$1" = "" ]; then
	echo "usage: $0 <url>"
	exit 1
fi

path="/usr/local/share/ca-certificates/courier"
base="`basename $1`"
filename="${base%.*}"
extension="${base##*.}"

wget -P $path "$1"

if [ "$extension" != "crt" ]; then
	mv $path/$base $path/$filename.crt
fi

c_rehash
update-ca-certificates

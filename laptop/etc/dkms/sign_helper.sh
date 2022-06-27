#!/usr/bin/sh


if [ -f "/secret/MOK.priv" ]
then
	echo "Signing module $2"
	/lib/modules/"$1"/build/scripts/sign-file sha512 \
		/secret/MOK.priv /secret/MOK.der "$2"
else
	echo "Could not find module signing keys"
	exit 1
fi

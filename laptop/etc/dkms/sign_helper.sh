#!/usr/bin/sh

if [ -d "/run/media/kal/Module Signing" ]
then
	echo "Signing module $2"
	/lib/modules/"$1"/build/scripts/sign-file sha512 \
		"/run/media/kal/Module Signing/MOK.priv" \
		"/run/media/kal/Module Signing/MOK.der" "$2"
else
	echo "Could not find module signing keys"
	exit 1
fi

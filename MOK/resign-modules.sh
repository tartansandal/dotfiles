#!/bin/bash

set -e

sudo --validate

# only look for modules matching this find spec
matchers="-name 'vbox*.ko' -o -name nvidia*.ko"

# If we have just installed a kernel, it may not be the current, so we just
# try to sign everything we can find
for kernel in $(ls -1 /usr/src/kernels/ | grep -v debug)
do
    modules=$(find /lib/modules/$kernel $matchers 2>/dev/null)

    if [[ -z $modules ]]
    then
        echo "Could not find any modules to sign for kernal $kernel"
        continue
    fi

    echo "Found the following modules for kernel $kernel"
    for module in ${modules[*]}
    do
        echo $module
    done

    read -p "Do you want to sign these modules? (y|N) " reply

    if [[ $reply == 'y' || $reply == 'Y' ]]
    then
        for module in ${modules[*]}
        do
            echo signing $module
            sudo /usr/src/kernels/$kernel/scripts/sign-file sha256 MOK.priv MOK.der $module
        done
    fi
done

# Try to load the matching drivers
sudo modprobe vboxdrv
sudo modprobe nvidia

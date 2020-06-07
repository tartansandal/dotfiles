#!/bin/bash


modules=$(find /lib/modules -name '*.ko' -exec grep -FL '~Module signature appended~' {} \+)

set -e

if [[ -z $modules ]]
then
    echo "Could not find any unsigned modules"
    echo
    exit
fi

sudo --validate

for module in ${modules[*]}
do
    echo "Found the following unsinged module:"
    echo $module
    read -p "Do you want to sign this module? (y|N) " reply

    if [[ $reply == 'y' || $reply == 'Y' ]]
    then
        for module in ${modules[*]}
        do
            echo signing $(basename $module)
            sudo /usr/src/kernels/$kernel/scripts/sign-file sha256 MOK.priv MOK.der $module
        done
        echo
    fi
    done
echo

# Try to load the matching drivers
# sudo modprobe vboxdrv
# sudo modprobe nvidia

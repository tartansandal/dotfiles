#!/bin/bash

set -e

sudo --validate

for kernel_path in /usr/src/kernels/*
do
    kernel=$(basename $kernel_path)
    modules=$(find /lib/modules/$kernel -name '*.ko' \
                -exec grep -FL '~Module signature appended~' {} \; )

    if [[ -z $modules ]]
    then
        echo "Could not find any unsigned modules for kernel-$kernel"
        continue
    fi

    printf "\nFound the following unsigned modules for kernel-$kernel:\n\n"
    for module_path in ${modules[*]}
    do
        printf "\t$(basename $module_path .ko)\n"
    done
    echo

    read -p "Do you want to sign these modules? (y|N) " reply

    if [[ $reply == 'y' || $reply == 'Y' ]]
    then
        echo
        for module_path in ${modules[*]}
        do
            echo signing $module_path
            sudo /usr/src/kernels/$kernel/scripts/sign-file \
                sha256 MOK.priv MOK.der $module_path
        done
    fi
    echo
done

# Try to load the matching drivers
# sudo modprobe vboxdrv
# sudo modprobe nvidia

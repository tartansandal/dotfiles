#!/bin/bash

set -e

sudo --validate

# If we have just installed a kernel, it may not be the current, so we just
# sign everything we can find
for kernel in $(ls -1 /usr/src/kernels/ | grep -v debug)
do
    modules=$(find /lib/modules/$kernel -name 'vbox*.ko' -o -name 'evdi.ko' 2>/dev/null)
    for module in ${modules[*]}
    do
        echo signing $module
        sudo /usr/src/kernels/$kernel/scripts/sign-file sha256 MOK.priv MOK.der $module
    done
done

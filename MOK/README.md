# Setting and using Machine Owner Keys

These are used to sign kernel modules using a private key accessible only to the
machine owner. I keep these on an encrypted external thumb drive that I only
plug in when signing 3rd party modules.  This is a single purpose drive that
contains the keys, helper scripts, and some documentation.

## Setting up (new) MOK keys

1. Mount the thumb drive and open a terminal in the top level
2. Run the `setup-new-keys.sh` script
3. You will be asked for a temporary password. Remember this to complete the
   next steps.
4. Reboot.
5. The MokManager should be loaded.
6. Enrol the new key using your temporary password.

## Setting up a new thumb drive

1. Create a LUKS encrypted thumb drive.
2. Copy across the files from the `~/dotfiles/MOK` directory.
3. Perform the "Setting up new MOK keys" dance
4. Mount the thumb drive after the reboot and ope a terminal in the top level.
5. Run the `resign-modules.sh` script.
6. Possibly reboot.

## References

[Crowdstrike]: https://www.crowdstrike.com/blog/enhancing-secure-boot-chain-on-fedora-29/
[Fedora]: https://docs.fedoraproject.org/en-US/Fedora/23/html/System_Administrators_Guide/sect-enrolling-public-key-on-target-system.html
[Attie]: https://attie.co.uk/wiki/ubuntu/secure_boot/sign_modules/
[Ubundtu]: https://wiki.ubuntu.com/UEFI/SecureBoot

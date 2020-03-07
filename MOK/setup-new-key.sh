#!/usr/bin/env bash

openssl req             \
    -new                \
    -x509               \
    -newkey rsa:2048    \ 
    -keyout MOK.priv    \
    -outform DER        \
    -out MOK.der        \
    -nodes              \
    -days 36500         \
    -subj "/CN=My New Key/"
chmod 600 MOK.priv 
mokutil --import MOK.der
sync

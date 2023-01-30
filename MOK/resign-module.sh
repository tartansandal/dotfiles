#!/usr/bin/env bash

readonly hash_algo='sha256'
readonly key='./MOK.priv'
readonly x509='./MOK.der'

readonly script_name="$(basename $0)"
readonly esc='\\e'
readonly reset="${esc}[0m"

readonly sign_file="/usr/src/kernels/$(uname -r)/scripts/sign-file"

readonly module_name="$1"

green() { local string="${1}"; echo -e "${esc}[32m${string}${reset}"; }
blue() { local string="${1}"; echo -e "${esc}[34m${string}${reset}"; }
log() { local string="${1}"; echo -e "[$(blue $script_name)] ${string}"; }

if [[ ${UID} != 0 ]]
then
    log "You must run this script as root"
    exit 1
fi

if [[ -z ${module_name} ]]
then
    log "USAGE: ${script_name} <module name>"
    exit 1
fi

for module_path in $(dirname $(modinfo -n ${module_name}))/*.ko.xz
do
    if [[ $(basename "${module_path}" .xz) != "${module_path}" ]]
    then
        log "decompress module_path ${module_path}"
        xz -d ${module_path}
    fi

    log "Signing $(green ${module_path})..."
    path=$(dirname "${module_path}")
    decompressed=$(basename "${module_path}" .xz)
    $sign_file "${hash_algo}" "${key}" "${x509}" "${path}/${decompressed}"

    if [[ $(basename "${module_path}" .xz) != "${module_path}" ]]
    then
        log "recompress module_path ${module_path}"
        xz "${path}"/"${decompressed}"
    fi
done

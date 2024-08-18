#!/bin/bash

function process_bw_png() {
    local file="${1}"

    mogrify -colorspace Gray "${file}"
    echo $(date +'[%F %T]') [${file}] ✓
    ./pdfsizeopt/pdfsizeopt_libexec/pngout "${file}" -c0 -b0 -q
    ./pdfsizeopt/pdfsizeopt_libexec/pngout "${file}" -c0 -b128 -q
    ./pdfsizeopt/pdfsizeopt_libexec/pngout "${file}" -c0 -b192 -q
    ./pdfsizeopt/pdfsizeopt_libexec/pngout "${file}" -c0 -b256 -q
    ./pdfsizeopt/pdfsizeopt_libexec/pngout "${file}" -c0 -b384 -q
    ./pdfsizeopt/pdfsizeopt_libexec/pngout "${file}" -c0 -b512 -q
    ./pdfsizeopt/pdfsizeopt_libexec/pngout "${file}" -c0 -b1024 -q
    echo $(date +'[%F %T]') [${file}] ✓✓
}

export -f process_bw_png

find images/ -name '*.png' \
    | sort \
    | grep -v '\(chapter\|logo\).png' \
    | xargs -P8 -I {} bash -c 'process_bw_png "$@"' _ {}

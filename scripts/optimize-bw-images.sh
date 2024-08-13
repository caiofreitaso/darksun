#!/bin/bash

function process_bw_png() {
    local file="${1}"

    mogrify -colorspace Gray "${file}"
    echo $(date +'[%F %T]') [${file}] ✓
    optipng -q -o7 "${file}"
    echo $(date +'[%F %T]') [${file}] ✓✓
}

export -f process_bw_png

find images/ -name '*.png' \
    | sort \
    | grep -v '\(chapter\|logo\).png' \
    | xargs -P8 -I {} bash -c 'process_bw_png "$@"' _ {}

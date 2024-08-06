#!/bin/bash

PNG_IMAGES=$(find images/ -name '*.png' | sort | grep -v '\(chapter\|logo\).png')

function process_bw_png() {
    local file="${1}"

    mogrify -colorspace Gray "${file}"
    echo "✓  ${file}"
    optipng -q -o7 "${file}"
    echo "✓✓ ${file}"
}

export -f process_bw_png

echo "${PNG_IMAGES[@]}" | xargs -P8 -I {} bash -c 'process_bw_png "$@"' _ {}

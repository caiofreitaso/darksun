#!/bin/bash

TARGET="${1}"
OUTPUT="${2}"
BOOKMARK="${3:-${TARGET}}"

echo $(date +'[%F %T]') [${TARGET}] Updating bookmarks

pdftk "${TARGET}.pdf" update_info "${BOOKMARK}.bookmarks" output "${TARGET}_bookmark.pdf"
mv "${TARGET}_bookmark.pdf" "${TARGET}.pdf"

echo $(date +'[%F %T]') [${TARGET}] Finish bookmarks



echo $(date +'[%F %T]') [${TARGET}] Optimizing PDF

./pdfsizeopt/pdfsizeopt.single --v=10 --tmp-dir=/tmp ${TARGET}.pdf
mv "${TARGET}.pso.pdf" "${OUTPUT}.pdf"

echo $(date +'[%F %T]') [${TARGET}] Optimized

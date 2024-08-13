#!/bin/bash

function log() {
  echo $(date +'[%F %T]') $@
}

function get_bookmark_line() {
  local start_page="${1}"

  if [[ ${start_page} == "end" ]]
  then
    awk 'END { print NR + 4 }' dark-sun.bookmarks
  else
    awk '
      BEGIN { found = 0 }
      /^BookmarkLevel: 1$/ { found++; next }
      /^BookmarkPageNumber: '"${start_page}"'$/ && found { print NR; exit }
      { found = 0 }
    ' dark-sun.bookmarks
  fi
}

function get_end_bookmark() {
  local end="${1}"
  local end_bookmark=$(( $(get_bookmark_line "${end}") - 4 ))
  
  if [[ "${end}" != "end" ]]
  then
    end=$(( ${end} - 2 ))
  fi

  echo "${end}"
}

function split_pdf() {
  local target="${1}"
  local start="${2}"
  local end="${3}"
  local output="${4}"

  log [${output}] Start bare split

  pdftk "${target}.pdf" cat "${start}-${end}" output "${output}_bare.pdf" &
  sed -n "${start_bookmark},${end_bookmark}{p;${end_bookmark}q}" dark-sun.bookmarks \
    | awk '/^BookmarkLevel: / {$2 -= 1} /^BookmarkPageNumber: / {$2 -= '"$(( ${start} - 1 ))"'} { print $0 }' \
    > "${output}.bookmarks" &
  wait
  mv "${output}_bare.pdf" "${output}.pdf"
  log [${output}] Finish bare split
}

TARGET="${1}"
OUTPUT="${TARGET}_${4}"

log [${output}] Get bookmark information

START=$(( $(get_bookmark_line "${2}") + 1 ))
END=$(get_end_bookmark "${3}")

split_pdf "${TARGET}" "${START}" "${END}" "${OUTPUT}"
./scripts/create-low-res.sh ${OUTPUT}
./scripts/optimize_pdf.sh ${OUTPUT}_low-res ${OUTPUT} ${OUTPUT}

log [${OUTPUT}] Finish

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
  
  if [[ "${end}" != "end" ]]
  then
    end=$(( ${end} - 2 ))
  fi

  echo "${end}"
}

function create_bookmarks() {
  local output="${1}"
  local start="${2}"
  local end="${3}"

  log [${output}] Creating bookmarks

  local start_bookmark=$(( $(get_bookmark_line "${start}") + 1 ))
  local end_bookmark=$(( $(get_bookmark_line "${end}") - 4 ))

  log [${output}] [bookmark] ${start_bookmark},${end_bookmark}

  sed -n "${start_bookmark},${end_bookmark}{p;${end_bookmark}q}" dark-sun.bookmarks \
    | awk '/^BookmarkLevel: / {$2 -= 1} /^BookmarkPageNumber: / {$2 -= '"$(( ${start} - 1 ))"'} { print $0 }' \
    > "${output}.bookmarks"

  log [${output}] Created bookmarks
}

function split_pdf() {
  local target="${1}"
  local start="${2}"
  local end=$(get_end_bookmark "${3}")
  local output="${4}"

  log [${output}] Start bare split

  pdftk "${target}.pdf" cat "${start}-${end}" output "${output}_bare.pdf"
  mv "${output}_bare.pdf" "${output}.pdf"

  log [${output}] Finish bare split
}

TARGET="${1}"
START="${2}"
END="${3}"
OUTPUT="${TARGET}_${4}"

create_bookmarks "${OUTPUT}" "${START}" "${END}" &
split_pdf "${TARGET}" "${START}" "${END}" "${OUTPUT}" &
wait

./scripts/create-low-res.sh ${OUTPUT}
./scripts/optimize-pdf.sh ${OUTPUT}_low-res ${OUTPUT} ${OUTPUT}

log [${OUTPUT}] Finish

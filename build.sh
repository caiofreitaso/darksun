#!/bin/bash

function create_pdf(){
  rubber -d $1
  rubber --clean $1
}

function create_lowres() {
  local target="${1}"
  gs \
  -sOutputFile="${target}_low-res.pdf" \
  -sDEVICE=pdfwrite \
  -dCompatibilityLevel=1.4 \
  -dPDFSETTINGS=/screen \
  -dNOPAUSE \
  -dQUIET \
  -dBATCH "${target}.pdf"
}

function get_chapter_page() {
  local chapter="${1}"
  local chapter_number="${2}"
  
  pdfgrep dark-sun.pdf -e "${2} ${1}" | head -n1 | awk '{ print $3 }'
}

function split_pdf() {
  local target="${1}"
  local start="${2}"
  local end="${3}"
  local output="${4}"
  
  pdftk "${target}.pdf" cat "${start}-${end}" output "${target}_${output}.pdf"
}

create_pdf credits-and-legal &
create_pdf ogl &
wait
create_pdf dark-sun

CURRENT_FILENAME="dark-sun.$(date +"%Y-%m-%dT%H-%M").pdf"
cp dark-sun.pdf "${CURRENT_FILENAME}"

MAGIC_PAGE=$(get_chapter_page Magic 10)
PSIONICS_PAGE=$(get_chapter_page Psionics 12)
DM_PAGE=$(get_chapter_page Combat 14)

#create_lowres dark-sun &
split_pdf dark-sun 1 $(( ${MAGIC_PAGE} - 2 )) players &
split_pdf dark-sun $(( ${MAGIC_PAGE} - 1 )) $(( ${PSIONICS_PAGE} - 2 )) magic &
split_pdf dark-sun $(( ${PSIONICS_PAGE} - 1 )) $(( ${DM_PAGE} - 2 )) psionics &
split_pdf dark-sun $(( ${DM_PAGE} - 1 )) end dungeon-master &
wait
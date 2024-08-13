#!/bin/bash

function log() {
  echo $(date +'[%F %T]') $@
}

function create_pdf(){
  rubber -d $1
  rubber --clean $1
}

function create_lowres() {
  local output="${1}"
  local low_res="${output}_low-res"

  log [${low_res}] Start low-resolution first pass
  gs \
  -sOutputFile="${low_res}.pdf" \
  -sDEVICE=pdfwrite \
  -dCompatibilityLevel=1.5 \
  -dPDFSETTINGS=/screen \
  -dNOPAUSE \
  -dQUIET \
  -dBATCH \
  "${output}.pdf"
  log [${low_res}] Finish low-resolution first pass

  optimize_pdf ${low_res} ${output}
  mv ${low_res}.pso.pdf ${low_res}.pdf
}

function optimize_pdf() {
  local output="${1}"
  local bookmark="${2:-${output}}"

  pdftk "${output}.pdf" update_info "${bookmark}.bookmarks" output "${output}_bookmark.pdf"
  mv "${output}_bookmark.pdf" "${output}.pdf"
  log [${output}] Finish bookmarks

  log [${output}] Start optimizing
  ./pdfsizeopt/pdfsizeopt.single --v=10 --tmp-dir=/tmp ${output}.pdf
  log [${output}] Finish optimizing

}

function update_pdfsizeopt() {
  local libexec_uri="$(awk '/Linux: / {print $2}' ./pdfsizeopt/latest_libexec.txt)"
  local target_folder="./pdfsizeopt/pdfsizeopt_libexec"

  log [pdfsizeopt] Get external dependencies

  wget -q -O- "${libexec_uri}" | tar -xz -C "./pdfsizeopt"

  log [pdfsizeopt] Finish external dependencies
}

function get_part_page() {
  local part="${1}"
  local part_number="${2}"
  local line=$(grep dark-sun.bookmarks -ne "Title: ${part_number} ${part}" | awk -F: '{ print $1 }')

  sed "$(( ${line} + 2 ))q;d" dark-sun.bookmarks \
    | awk '{ print $2 }'

  # pdfgrep dark-sun.pdf -e "${part}" -m 1 \
  #  | awk 'match($0, /'"${part_number}"' +'"${part}"' +([0-9]+)/, groups) { print groups[1] }'
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

function split_pdf() {
  local target="${1}"
  local start="${2}"
  local end="${3}"
  local output="${target}_${4}"

  log [${output}] Get bookmark information

  local start_bookmark=$(( $(get_bookmark_line "${start}") + 1 ))
  local end_bookmark=$(( $(get_bookmark_line "${end}") - 4 ))
  
  if [[ "${end}" != "end" ]]
  then
    end=$(( ${end} - 2 ))
  fi

  log [${output}] Start split

  pdftk "${target}.pdf" cat "${start}-${end}" output "${output}_bare.pdf" &
  sed -n "${start_bookmark},${end_bookmark}{p;${end_bookmark}q}" dark-sun.bookmarks \
    | awk '/^BookmarkLevel: / {$2 -= 1} /^BookmarkPageNumber: / {$2 -= '"$(( ${start} - 1 ))"'} { print $0 }' \
    > "${output}.bookmarks" &
  wait
  mv "${output}_bare.pdf" "${output}.pdf"
  log [${output}] Finish bare split

  create_lowres ${output}
  mv ${output}_low-res.pdf ${output}.pdf

  log [${output}] Finish
}

############
### MAIN ###
############

CURRENT_FILENAME="dark-sun.$(date +"%Y-%m-%dT%H-%M").pdf"

./scripts/optimize-bw-images.sh &
update_pdfsizeopt &
create_pdf credits-and-legal &
create_pdf ogl &
wait

create_pdf dark-sun
pdftk dark-sun.pdf dump_data \
  | grep -e Bookmark \
  | sed 's/&apos;/’/g' > dark-sun.bookmarks

# optimize_pdf dark-sun &
create_lowres dark-sun &

PHB_PAGE=$(get_part_page "Player’s Handbook" I)
ITEMS_PAGE=$(get_part_page "Athasian Emporium" II)
MAGIC_PAGE=$(get_part_page "Universae Grimoire" III)
PSIONICS_PAGE=$(get_part_page "The Will and The Way" IV)
WORLD_PAGE=$(get_part_page "Wanderer’s Journal" V)
DM_PAGE=$(get_part_page "Dungeon Master’s Guide" VI)

split_pdf dark-sun ${PHB_PAGE} ${ITEMS_PAGE} 1_players &
split_pdf dark-sun ${ITEMS_PAGE} ${MAGIC_PAGE} 2_items &
split_pdf dark-sun ${MAGIC_PAGE} ${PSIONICS_PAGE} 3_magic &
split_pdf dark-sun ${PSIONICS_PAGE} ${WORLD_PAGE} 4_psionics &
split_pdf dark-sun ${WORLD_PAGE} ${DM_PAGE} 5_wanderer &
split_pdf dark-sun ${DM_PAGE} end 6_dungeon-master &
wait

rm *.bookmarks
mv dark-sun.pso.pdf "${CURRENT_FILENAME}"

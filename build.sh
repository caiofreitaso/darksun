#!/bin/bash

function log() {
  echo $(date +'[%F %T]') $@
}

function create_pdf(){
  rubber -d $1
  rubber --clean $1
}

function usage() {
  echo "Usage: ${0} [-cilosu]"
  echo -e '\t-c\tCreate dark-sun.pdf'
  echo -e '\t-i\tOptimize images in ./images/'
  echo -e '\t-l\tCreate low resolution PDF (name: dark-sun.<current_date>.pdf)'
  echo -e '\t-o\tOptimize dark-sun.pdf'
  echo -e '\t-s\tSplit dark-sun into different parts'
  echo -e '\t-u\tUpdate external dependencies for pdfsizeopt'

  exit 1
}

############
### MAIN ###
############

CURRENT_FILENAME="dark-sun.$(date +"%Y-%m-%dT%H-%M").pdf"

while getopts 'cilosu' OPTION
do
  case "${OPTION}" in
    c)
      CREATE_PDF=1;;
    i)
      OPTIMIZE_IMAGE=1;;
    l)
      LOW_RES=1;;
    o)
      OPTIMIZE_PDF=1;;
    s)
      SPLIT_PDF=1;;
    u)
      UPDATE_PDFSIZEOPT=1;;
    *)
      usage;;
  esac
done

if [[ ${OPTIMIZE_IMAGE} ]]
then
  ./scripts/optimize-bw-images.sh &
fi

if [[ ${UPDATE_PDFSIZEOPT} ]]
then
  ./scripts/update-pdfsizeopt.sh &
fi

if [[ ${CREATE_PDF} ]]
then
  create_pdf credits-and-legal &
  create_pdf ogl &
  wait

  create_pdf dark-sun
fi

pdftk dark-sun.pdf dump_data \
  | grep -e Bookmark \
  | sed 's/(&apos;|&#8217;)/’/g' > dark-sun.bookmarks

if [[ ${OPTIMIZE_PDF} ]]
then
  ./scripts/optimize-pdf.sh dark-sun "${CURRENT_FILENAME}" &
fi

if [[ ${LOW_RES} ]]
then
  ./scripts/create-low-res.sh dark-sun &
fi

if [[ ${SPLIT_PDF} ]]
then
  PHB_PAGE=$(./scripts/find-part-page.sh "Player\(’\|\&#8217;\)s Handbook" I)
  ITEMS_PAGE=$(./scripts/find-part-page.sh "Athasian Emporium" II)
  MAGIC_PAGE=$(./scripts/find-part-page.sh "Universae Grimoire" III)
  PSIONICS_PAGE=$(./scripts/find-part-page.sh "The Will and The Way" IV)
  WORLD_PAGE=$(./scripts/find-part-page.sh "Wanderer\(’\|\&#8217;\)s Journal" V)
  DM_PAGE=$(./scripts/find-part-page.sh "Dungeon Master\(’\|\&#8217;\)s Guide" VI)

  ./scripts/split-pdf.sh dark-sun ${PHB_PAGE} ${ITEMS_PAGE} 1_players &
  ./scripts/split-pdf.sh dark-sun ${ITEMS_PAGE} ${MAGIC_PAGE} 2_items &
  ./scripts/split-pdf.sh dark-sun ${MAGIC_PAGE} ${PSIONICS_PAGE} 3_magic &
  ./scripts/split-pdf.sh dark-sun ${PSIONICS_PAGE} ${WORLD_PAGE} 4_psionics &
  ./scripts/split-pdf.sh dark-sun ${WORLD_PAGE} ${DM_PAGE} 5_wanderer &
  ./scripts/split-pdf.sh dark-sun ${DM_PAGE} end 6_dungeon-master &
fi

wait

rm *.bookmarks

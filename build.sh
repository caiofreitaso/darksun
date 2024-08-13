#!/bin/bash

function log() {
  echo $(date +'[%F %T]') $@
}

function create_pdf(){
  rubber -d $1
  rubber --clean $1
}

############
### MAIN ###
############

CURRENT_FILENAME="dark-sun.$(date +"%Y-%m-%dT%H-%M").pdf"

./scripts/optimize-bw-images.sh &
./scripts/update-pdfsizeopt.sh &
create_pdf credits-and-legal &
create_pdf ogl &
wait

create_pdf dark-sun
pdftk dark-sun.pdf dump_data \
  | grep -e Bookmark \
  | sed 's/&apos;/’/g' > dark-sun.bookmarks

./scripts/optimize-pdf.sh dark-sun "${CURRENT_FILENAME}" &
./scripts/create-low-res.sh dark-sun &

PHB_PAGE=$(./scripts/find-part-page.sh "Player’s Handbook" I)
ITEMS_PAGE=$(./scripts/find-part-page.sh "Athasian Emporium" II)
MAGIC_PAGE=$(./scripts/find-part-page.sh "Universae Grimoire" III)
PSIONICS_PAGE=$(./scripts/find-part-page.sh "The Will and The Way" IV)
WORLD_PAGE=$(./scripts/find-part-page.sh "Wanderer’s Journal" V)
DM_PAGE=$(./scripts/find-part-page.sh "Dungeon Master’s Guide" VI)

./scripts/split-pdf.sh dark-sun ${PHB_PAGE} ${ITEMS_PAGE} 1_players &
./scripts/split-pdf.sh dark-sun ${ITEMS_PAGE} ${MAGIC_PAGE} 2_items &
./scripts/split-pdf.sh dark-sun ${MAGIC_PAGE} ${PSIONICS_PAGE} 3_magic &
./scripts/split-pdf.sh dark-sun ${PSIONICS_PAGE} ${WORLD_PAGE} 4_psionics &
./scripts/split-pdf.sh dark-sun ${WORLD_PAGE} ${DM_PAGE} 5_wanderer &
./scripts/split-pdf.sh dark-sun ${DM_PAGE} end 6_dungeon-master &
wait

rm *.bookmarks

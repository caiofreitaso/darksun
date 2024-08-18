#!/bin/bash

function log() {
  echo $(date +'[%F %T]') $@
}

function create_pdf(){
  rubber -d $1
  rubber --clean $1

  log [$1] PDF compiled
}

function usage() {
  echo "Usage: ${0} [OPTIONS]"
  echo -e '\t-c, --create         \tCreate dark-sun.pdf'
  echo -e '\t-h, --help           \tDisplay this information'
  echo -e '\t-i, --optimize-images\tOptimize images in ./images/'
  echo -e '\t-l, --low-res        \tCreate low resolution PDF (name: dark-sun_low-res.pdf)'
  echo -e '\t-o, --optimize-pdf   \tOptimize dark-sun.pdf (name: dark-sun.<current_date>.pdf)'
  echo -e '\t-s, --split          \tSplit dark-sun into different parts'
  echo -e '\t-u, --update         \tUpdate external dependencies for pdfsizeopt'
}

function needs_arg() {
  if [ -z "$OPTARG" ]
  then
    echo "No arg for --$OPT option" >&2
    exit 1
  fi
}

############
### MAIN ###
############

CURRENT_FILENAME="dark-sun.$(date +"%Y-%m-%dT%H-%M")"
BOOKMARKS=false
CREATE_PDF=false
LOW_RES=false
OPTIMIZE_IMAGE=false
OPTIMIZE_PDF=false
SPLIT_PDF=false
UPDATE_PDFSIZEOPT=false

while getopts 'chilosu-:' OPTION
do
  # support long options: https://stackoverflow.com/a/28466267/519360
  if [ "${OPTION}" = "-" ]; then   # long option: reformulate OPTION and OPTARG
    OPTION="${OPTARG%%=*}"         # extract long option name
    OPTARG="${OPTARG#"${OPTION}"}"   # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"           # if long option argument, remove assigning `=`
  fi

  case "${OPTION}" in
    c | create-pdf)
      CREATE_PDF=true
      BOOKMARKS=true
      echo "- create pdf";;
    h | help)
      usage
      exit 0;;
    i | optimize-images)
      OPTIMIZE_IMAGE=true
      echo "- optimize images";;
    l | low-res)
      LOW_RES=true
      BOOKMARKS=true
      echo "- create low resolution";;
    o | optimize-pdf)
      OPTIMIZE_PDF=true
      BOOKMARKS=true
      echo "- optimize pdf";;
    s | split)
      SPLIT_PDF=true
      BOOKMARKS=true
      echo "- split into parts";;
    u | update)
      UPDATE_PDFSIZEOPT=true
      echo "- update pdfsizeopt";;
    *)
      usage >&2
      exit 1;;
  esac
done

if ${UPDATE_PDFSIZEOPT}
then
  ./scripts/update-pdfsizeopt.sh
fi

if ${OPTIMIZE_IMAGE}
then
  ./scripts/optimize-bw-images.sh &
fi

if ${CREATE_PDF}
then
  create_pdf credits-and-legal &
  create_pdf ogl &
  wait

  create_pdf dark-sun
fi

if ${BOOKMARKS}
then
  pdftk dark-sun.pdf dump_data | grep -e Bookmark | sed 's/\(&apos;\|&#8217;\)/’/g' > dark-sun.bookmarks
  log [dark-sun] Extracted bookmarks
fi

if ${OPTIMIZE_PDF}
then
  ./scripts/optimize-pdf.sh dark-sun --bookmark="${CURRENT_FILENAME}"
fi

if ${LOW_RES}
then
  ./scripts/create-low-res.sh dark-sun
  ./scripts/optimize-pdf.sh dark-sun_low-res --bookmark=dark-sun --optimize-images
fi &

if ${SPLIT_PDF}
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

if ${BOOKMARKS}
then
  rm *.bookmarks
fi

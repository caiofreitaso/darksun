#!/bin/bash

SCRIPT_NAME="${0}"
TARGET="${1}"
OPTIMIZE_IMAGE="no"

function usage() {
  echo "Usage: ${SCRIPT_NAME} target-prefix [OPTIONS]"
  echo -e '\t-b, --bookmark=PREFIX\tBookmark prefix (default: target-prefix)'
  echo -e '\t-o, --output=PREFIX  \tOutput prefix (default: target-prefix)'
  echo -e '\t-i, --optimize-images\tOptimize images'
  echo -e '\t-h, --help           \tDisplay this information'
}

function needs_arg() {
  if [ -z "${OPTARG}" ]
  then
    echo "${SCRIPT_NAME}: no arg for --${OPTION} option" >&2
    exit 1
  fi
}

if [ -z "${TARGET}" ]
then
    echo "${SCRIPT_NAME}: no target prefix" >&2
    exit 1
fi

if [[ "${TARGET}" == "--help" || "${TARGET}" == "-h" ]]
then
    usage
    exit 0
fi

shift 1

while getopts 'b:hio:-:' OPTION
do
  # support long options: https://stackoverflow.com/a/28466267/519360
  if [ "${OPTION}" = "-" ]         # long option: reformulate OPTION and OPTARG
  then
    OPTION="${OPTARG%%=*}"         # extract long option name
    OPTARG="${OPTARG#"${OPTION}"}" # extract long option argument (may be empty)
    OPTARG="${OPTARG#=}"           # if long option argument, remove assigning `=`
  fi

  case "${OPTION}" in
    b | bookmark)
      needs_arg
      BOOKMARK="${OPTARG}";;
    h | help)
      usage
      exit 0;;
    i | optimize-images)
      OPTIMIZE_IMAGE="yes";;
    o | output)
      needs_arg
      OUTPUT="${OPTARG}";;
    *)
      usage >&2
      exit 1;;
  esac
done

BOOKMARK="${BOOKMARK:-${TARGET}}"
OUTPUT="${OUTPUT:-${TARGET}}"


echo $(date +'[%F %T]') [${TARGET}] Updating bookmarks

pdftk "${TARGET}.pdf" update_info "${BOOKMARK}.bookmarks" output "${TARGET}_bookmark.pdf"
mv "${TARGET}_bookmark.pdf" "${TARGET}.pdf"

echo $(date +'[%F %T]') [${TARGET}] Finish bookmarks



echo $(date +'[%F %T]') [${TARGET}] Optimizing PDF

./pdfsizeopt/pdfsizeopt.single --do-optimize-images=${OPTIMIZE_IMAGE} --v=10 --tmp-dir=/tmp ${TARGET}.pdf
mv "${TARGET}.pso.pdf" "${OUTPUT}.pdf"

echo $(date +'[%F %T]') [${TARGET}] Optimized to ${OUTPUT}.pdf

#!/bin/bash

PART_NAME="${1}"
PART_NUMBER="${2}"
BOOKMARK_LINE=$(grep dark-sun.bookmarks -ne "Title: ${PART_NUMBER} ${PART_NAME}" | awk -F: '{ print $1 }')

sed "$(( ${BOOKMARK_LINE} + 2 ))q;d" dark-sun.bookmarks \
  | awk '{ print $2 }'

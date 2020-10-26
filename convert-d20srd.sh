#!/bin/bash

FILE=$1
TARGETNAME=$(echo ${FILE} | rev | awk -F/ '{ gsub(/mth./,"",$0); print $1 }' | rev | sed 's/\([a-z0-9]\)\([A-Z]\)/\1-\L\2/g')

curl -s $1 | awk -f convert-d20srd.awk > subsections/spells/${TARGETNAME}.tex
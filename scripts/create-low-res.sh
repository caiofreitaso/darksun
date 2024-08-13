#!/bin/bash

OUTPUT="${1}"
LOW_RES="${OUTPUT}_low-res"

echo $(date +'[%F %T]') [${LOW_RES}] Start low-resolution first pass
gs \
  -sOutputFile="${LOW_RES}.pdf" \
  -sDEVICE=pdfwrite \
  -dCompatibilityLevel=1.5 \
  -dPDFSETTINGS=/screen \
  -dNOPAUSE \
  -dQUIET \
  -dBATCH \
  "${OUTPUT}.pdf"
echo $(date +'[%F %T]') [${LOW_RES}] Finish low-resolution first pass

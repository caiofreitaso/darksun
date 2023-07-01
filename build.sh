#!/bin/bash

function create_pdf(){
  rubber -d $1
  rubber --clean $1
}

create_pdf credits-and-legal &
create_pdf ogl &
wait
create_pdf dark-sun &
create_pdf dark-sun-dm &
create_pdf dark-sun-players &
wait
CURRENT_FILENAME="dark-sun.$(date +"%Y-%m-%dT%H-%M").pdf"
mv dark-sun.pdf "${CURRENT_FILENAME}"
gs \
  -sOutputFile="dark-sun.pdf" \
  -sDEVICE=pdfwrite \
  -dCompatibilityLevel=1.4 \
  -dPDFSETTINGS=/screen \
  -dNOPAUSE \
  -dQUIET \
  -dBATCH "${CURRENT_FILENAME}"

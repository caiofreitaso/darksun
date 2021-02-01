#!/bin/bash

function create_pdf(){
  rubber -d $1
  rubber --clean $1
}

create_pdf credits-and-legal &
create_pdf ogl &
wait
rubber -d dark-sun
cp dark-sun.pdf dark-sun.$(date +"%Y-%m-%dT%H-%M").pdf
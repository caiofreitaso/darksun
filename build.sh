#!/bin/bash

function create_pdf(){
  rubber -d $1
  rubber --clean $1
}

create_pdf credits-and-legal
create_pdf ogl
create_pdf dark-sun

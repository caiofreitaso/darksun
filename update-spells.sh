#!/bin/bash

SPELLS=sections/spells/spells.tex

echo "\section{Spell Descriptions}" > $SPELLS
echo "" >> $SPELLS
find subsections/spells/ -type f | sort | awk '{print "\\input{" $0 "}"}' >> $SPELLS
./build.sh

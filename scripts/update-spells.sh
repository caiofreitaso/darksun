#!/bin/bash

SPELLS=sections/spells/spells.tex

echo "\section{Spell Descriptions}" > $SPELLS
echo "The spells herein are presented in alphabetical order (with the exception of those whose names begin with ``greater,'' ``lesser,'' or ``mass''; see Order of Presentation)." >> $SPELLS
echo "" >> $SPELLS
find subsections/spells/ -type f | sort | awk '{print "\\input{" $0 "}"}' >> $SPELLS
./build.sh

#!/bin/bash

SPELLS=sections/spells/spells.tex

echo "\section{Spells}" > $SPELLS
echo "" >> $SPELLS
find subsections/spells/ -type f | sort | awk '{print "\\input{" $0 "}"}' >> $SPELLS
rubber -d dark-sun

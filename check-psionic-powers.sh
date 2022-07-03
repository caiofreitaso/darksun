#!/bin/bash

vimdiff <(find subsections/powers/ -name "*.tex" | sort) <(awk '{ if($0 ~ /input/) { print substr($0,8) } }' sections/powers/powers.tex | rev | cut -c 2- | rev)

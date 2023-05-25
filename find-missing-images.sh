#!/bin/bash

for image in $(find images/ -regex '.*\(jpe?g\|png\)' | sort)
do
	QUANTITY=$(find . -name "*.tex" -exec grep {} -e "^[^%]\+${image}" \; | wc -l)

	if [[ ${QUANTITY} == 0 ]]
	then
		echo ${image} missing.
	else
		if [[ ${QUANTITY} > 1 ]]
		then
			echo ${image} repeated.
		fi
	fi
done

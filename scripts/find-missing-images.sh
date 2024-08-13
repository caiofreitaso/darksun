#!/bin/bash

function get_quantity() {
	local image="${1}"
	local quantity=$(find . -name "*.tex" -exec grep {} -e "^[^%]\+${image}" \; | wc -l)

	if [[ ${quantity} == 0 ]]
	then
		echo ${image} missing.
	else
		if [[ ${quantity} > 1 ]]
		then
			echo ${image} repeated.
		fi
	fi
}

export -f get_quantity

find images/ -name '*.png' | sort | grep -v '\(chapter\|logo\).png' | xargs -P8 -I {} bash -c 'get_quantity "$@"' _ {}

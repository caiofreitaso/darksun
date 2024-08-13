#!/bin/bash

LIBEXEC_URI="$(awk '/Linux: / {print $2}' ./pdfsizeopt/latest_libexec.txt)"

echo $(date +'[%F %T]') [pdfsizeopt] Get external dependencies

wget -q -O- "${LIBEXEC_URI}" | tar -xz -C "./pdfsizeopt"

echo $(date +'[%F %T]') [pdfsizeopt] Finish external dependencies

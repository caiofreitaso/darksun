#!/bin/bash

find . -name '*.tex' | xargs grep -P -n "[^\x00-\x7F°]"

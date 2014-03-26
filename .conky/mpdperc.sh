#!/bin/bash

#perc=`mpc | grep [0-9][0-9]%`;
perc=`mpc | awk -F[\(\)] '{print $2}' | sed '1d' | sed 's/\(.*\)./\1/'`;
echo "$perc"

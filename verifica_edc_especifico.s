#!/bin/bash

EDCPATH=/phpoll/units
#EDCPATH=/phpoll/franq


if [ "$1" = "-h" -o $# -eq 0 ]; then
  echo "Uso: $0 [lista] [edc]"
fi 

lista=$1

for i in `get.s ${lista}`
do
	  echo "$i `grep $2 $EDCPATH/$i/edc/edc.ctl`"
done  


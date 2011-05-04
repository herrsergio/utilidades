#!/bin/bash

DATE=""
DISTRIB=""
SUM=0
CAT=0
FRAN=0

function usage(){
        echo -e "Usage:\t$0 [OPTIONS] ARGS"
        echo -e "  or\t$0 -h"
        echo -e "Verifica archivo de sums"
	echo -e "\t-l LIST_FILE\t archivo de la lista de distr"
	echo -e "\t-n NAME_FILE\t nombre del archivo de sums"
	echo -e "\t-s Para desplegar sum"
	echo -e "\t-c Para hacer un cat del archivo"
	echo -e "\t-f verificar franquicias"
        echo -e "\t-h Ayuda"
}

while getopts "l:n:schfp" OPTION
do
    case $OPTION in
        h)
            usage
	    exit 1
            ;;
        s)
            SUM=1
            ;;
        c)
            CAT=1
            ;;
        f)
            FRAN=1
            ;;
        l)
            DST_FILE=$OPTARG
            ;;
        n)
            SUM_FILE=$OPTARG
            ;;
        p)
            P=1
            ;;
        ?)
            usage
            exit 1
            ;;
    esac
done

if [[ -z $SUM ]] || [[ -z $CAT ]] || [[ -z $DST_FILE ]] || [[ -z $SUM_FILE ]]
then
    usage
    exit 1
fi

if [ $FRAN -eq 1 ]; then
    FU="franq"
else
    FU="units"
fi

for i in `cat /opt/prod/mlink/main/distrib/$DST_FILE`; 
do
    if [ $CAT -eq 1 ]; then
        if [ -e /phpoll/$FU/$i/edc/${SUM_FILE} ]; then
            echo "*****************************************************"
            echo -e "\t\t CC $i"
            echo -e "`cat /phpoll/$FU/$i/edc/${SUM_FILE}`"
        else
            echo -e "CC $i: NO EXISTE ARCHIVO"
        fi
    fi
    if [ $SUM -eq 1 ]; then
        if [ -e /phpoll/$FU/$i/edc/${SUM_FILE} ]; then
            echo -e "CC $i: `sum -r /phpoll/$FU/$i/edc/${SUM_FILE}` /phpoll/$FU/$i/edc/${SUM_FILE}"
        else
            echo -e "CC $i: NO EXISTE ARCHIVO"
        fi
    fi
done

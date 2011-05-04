#!/bin/bash

DATE=""
DISTRIB=""

function usage(){
        echo -e "Usage:\t$0 [OPTIONS] ARGS"
        echo -e "  or\t$0 -h"
        echo -e "Verifica archivo de cierre de lote de tarjeta de credito"
	echo "Argumentos:"
	echo -e "\t-l LIST_FILE\t archivo de la lista de distr"
	echo -e "\t-s DATE\t Fecha a revisar AA-MM-DD"
        echo "Opciones: "
        echo -e "\t-h Ayuda"
}

function parseArgs(){
        nargs=0
        val=0;

        while [ $# -gt 0 ]; do
                case $1 in
			-l) DISTRIB=$2
			    nargs=`expr $nargs + 1`
                            shift
                            ;;
			-s) DATE=$2
                            shift
                            ;;
                        -h) val=1
                            shift
                            ;;
                        *)  echo "$0: Opcion no valida--> $1"
                            echo "$0 -h para mas informacion"
                            val=1
                            ;;
                esac
                shift
        done

        if [ $nargs -ne 1 ]; then
                val=2;
        fi

        return $val
}

parseArgs $@
ret=$?

if [ $ret -ne 0 ]; then
        usage
        exit 
fi


for i in `cat /opt/prod/mlink/main/distrib/$DISTRIB`; 
do
    echo "*****************************************************"
    echo "\t\t CC $i"
    if [ -s /phpoll/units/$i/creditc/${DATE}.txt ]; then
        echo -e "`cat /phpoll/units/$i/creditc/${DATE}.txt`"
    else
        echo "CC $i : No hay archivo ${DATE}.txt"
    fi

    if [ -s /phpoll/units/$i/creditc/${DATE}.alarm ]; then
        echo "ALARMA:"
        echo "`cat /phpoll/units/$i/creditc/${DATE}.alarm`"
    fi
    
done

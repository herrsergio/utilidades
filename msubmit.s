# script que genera pendientes de poleo en forma diaria
# es llamado por el crontab de siscacm

USO="uso:  `basename $0` tasklist base_datos lista script
ejem: submit.s    d       main     =sus  suscroni"

if [ $# -ne 4 ]
then
	echo "$USO" >&2
	exit 1
fi

PATH=/opt/prod/mlink:/usr/bin/ph:.:$PATH
MLINK="/opt/prod/mlink"; export MLINK
MLDIR=/opt/prod/mlink; export MLDIR

export PATH MLINK

if [ ! -s $MLDIR/$2/request/$4.tkq ]
then
	echo "el script $MLDIR/$2/request/$4.tkq no se encontro!" >&2
	exit 1
fi

exec >~/acm_logs/submit.$4 2>&1

echo "************ INICIO: `date` ************\n"
echo args: $*

if [ "`echo $3 | cut -c1`" = "=" ]
then
	arch=`echo $3 | cut -c2-`
	if [ ! -s $MLDIR/$2/distrib/$arch.dst ]
	then
		echo "la lista $MLDIR/$2/distrib/$arch.dst no se encontro!" >&2
		exit 1
	fi
fi

#echo $MLINK $MLDIR
#type mlink

mlink -h amsubmit $2 f $1 $3 $4 2>&1

# Usage: mlink -h amsubmit [-t[<submit_id>]] [-r<retries>] [-p<pause>]
#	[-l<listname>] [-s] [-v] <database> <mode> <tasklist>
#	<parameters>
#
#	-t<submit_id>	Track submission; optionally use ID <submit_id>
#	-r<retries>		Retry up to <retries> times (0 = retry forever)
#	-p<pause>		Pause <pause> minutes between retries
#	-l<listname>	Use <listname> as name for retry list
#	-s				Save non-empty retry list
#	-v				Display summary of results
#	<database>		ACM database name
#	<tasklist>		Name of task list to modify
#
# Modes and parameters:
#   c - Submit single request
#       Parameters:  <sitelist> <request_text>
#   f - Submit file of requests
#       Parameters:  <sitelist> <request_file> [<date>]
#   l - Submit to list of distribution lists
#       Parameters:  <list_file> <request_file> [<date>]
#   w - Submit to wildcard distribution lists
#       Parameters:  <pattern> <request_file> [<date>]

echo "FIN: `date`\n\n"


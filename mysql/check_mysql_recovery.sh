#!/bin/sh

SCRIPT_NAME=`echo $0 | sed -e "s/.sh$//"`
[ -z "${TMP_DIR}" ] && TMP_DIR="/tmp"
TMP_FILE="${TMP_DIR}/${SCRIPT_NAME}.tmp.$$"
BACKUP_SQL="/home/backup/database_backups/kontain/2012/02/Thursday-01-12-11.30-kontain-mysqldump.sql"


SCRIPT_DATA="${TMP_DIR}/${SCRIPT_NAME}.tsv"
[ -f "${SCRIPT_DATA}" ] &&  LINES=`grep ${BACKUP_SQL} ${SCRIPT_DATA} | cut -d'	' -f1`

[ -z "${LINES}" ] && LINES=`cat ${BACKUP_SQL} 2>/dev/null | wc -l`
echo "Backup has ${LINES} lines"
echo "${LINES}	${BACKUP_SQL}" >> ${SCRIPT_DATA}

MYSQL_AUTHENTICATION="-urbradfor -psakila"

RUNNING_SQL=`mysql ${MYSQL_AUTHENTICATION} -e "SHOW PROCESSLIST" | grep -v "^Id" | grep -v "SHOW PROCESSLIST" | grep -v Sleep | head -1 | cut -f8- | cut -c1-40`

POS=`grep -n "'""${RUNNING_SQL}""'" ${BACKUP_SQL} | head -1 | cut  -d: -f1`

[ ! -z "${POS}" ] && PCT=`echo "${POS} ${LINES}" | awk '{printf "%0.2d", $1/$2*100}'`
echo "Estimate at ${POS} lines done, approximately ${PCT}%"

rm -f ${TMP_FILE}
exit 


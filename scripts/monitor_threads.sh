#!/bin/sh

[ -z "${TMP_DIR}" ] && TMP_DIR="/tmp"
TMP_FILE=${TMP_DIR}/`basename $0`.tmp.$$
HOSTNAME=`hostname`
[ -z "${MAX_THREADS_CONNECTED}" ] && MAX_THREADS_CONNECTED=1500
[ -z "${MAX_THREADS_RUNNING}" ] && MAX_THREADS_RUNNING=512

mysqladmin extended-status  >${TMP_FILE}
THREADS_CONNECTED=`grep -i threads_connected ${TMP_FILE} | cut -d'|' -f3 |tr -d ' '`
THREADS_RUNNING=`grep -i threads_running ${TMP_FILE} | cut -d'|' -f3 |tr -d ' '`
if [ ${THREADS_RUNNING} -gt ${MAX_THREADS_RUNNING} -o ${THREADS_CONNECTED} -gt ${MAX_THREADS_CONNECTED} ] 
then
  LOG=${TMP_DIR}/logger.`date +%Y%m%d.%H%M%S`.txt
  mysqladmin processlist > ${LOG}
  SUBJECT="${HOSTNAME} DB THREADS at ${THREADS_RUNNING}/${THREADS_CONNECTED} - "`date`
  ( 
    awk -f `dirname $0`/processlist.awk ${LOG}
    echo ""
    echo "For processlist details"
    echo "ssh ${HOSTNAME} cat ${LOG}"
  ) | sort -nr | mailx -s "${SUBJECT}" -r root@${HOSTNAME} rb42list@gmail.com rolan@omnistep.com daniel@news.net
fi

rm -f ${TMP_FILE}

exit 0

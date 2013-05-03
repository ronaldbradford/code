#!/bin/sh
# Script to monitor replication and report issues
#

SCRIPT_NAME=`basename $0 | sed -e "s/\.sh$//"`
[ -z "${TMP_DIR}" ] && TMP_DIR="/tmp/"
TMP_FILE=${TMP_DIR}${SCRIPT_NAME}.tmp.$$
[ -z "${MYSQL_AUTHENTICATION}" ] && MYSQL_AUTHENTICATION="-uroot"
[ -z "${MAX_SECS}" ] && MAX_SECS="60"
[ -z "${EMAIL}" ]  && EMAIL="name@example.com"

alert_error() {
  local MESSAGE="$*"

  sed -ie "1 i ${MESSAGE}" ${TMP_FILE}

  if [ ! -z "${EMAIL}" ]
  then
    SUBJECT="Replication Error on "`hostname`
    cat ${TMP_FILE} | mailx -s "${SUBJECT}" ${EMAIL}
  else
    cat ${TMP_FILE}
  fi
  exit 1
}


check_replication() {
  echo "Date: "`date` > ${TMP_FILE}
  echo "Host: "`hostname` >> ${TMP_FILE}
  [ -z `which mysql 2>/dev/null` ] && alert_error "ERROR:  mysql must be in the PATH."
  mysql ${MYSQL_AUTHENTICATION} -e "SHOW SLAVE STATUS\G" >> ${TMP_FILE}
  THREADS=`grep "Slave_.\+_Running" ${TMP_FILE} | sed -e"s/ //g" | awk -F: '{printf("%s"),$2}'`
  [ "${THREADS}" != "YesYes" ] && alert_error "ERROR:  One or more SQL Threads is not running"
  SECS=`grep Seconds_Behind_Master ${TMP_FILE} | sed -e "s/ //g" | cut -d: -f2`

  [ ${SECS} -gt ${MAX_SECS} ] && alert_error "ERROR:  Slave is more then '${MAX_SECS}' behind"

  return 0
}

check_replication
[ -z "${USE_DEBUG}" ] && rm -f ${TMP_FILE}
exit 0


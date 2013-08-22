#!/bin/sh


# Required Variables
#
BASE_DIR=`dirname $0`
SQL_DIR="${BASE_DIR}/../sql/"
LOG_DIR="${BASE_DIR}/../log/"
mkdir -p ${LOG_DIR}


# Required runtime config
#
[ -z "${MYCNF}" ] && MYCNF="${HOME}/.monitor.my.cnf"
[ ! -f "${MYCNF}" ] && echo "ERROR:  Unable to find  MySQL configuration '${MYCNF}'" && exit 1
MYSQL=`which mysql 2>/dev/null`
[ ! -f "${MYSQL}" ] && echo "ERROR: mysql not found in PATH" && exit 1


LOG_FILE="${LOG_DIR}schemas.log"
OPTIONS="-N"
[ ! -s "${LOG_FILE}" ] && OPTIONS=""
${MYSQL} --defaults-file=${MYCNF} ${OPTIONS} < ${SQL_DIR}audit_schemas.sql >> ${LOG_FILE}


LOG_FILE="${LOG_DIR}tables.log"
OPTIONS="-N"
[ ! -s "${LOG_FILE}" ] && OPTIONS=""
${MYSQL} --defaults-file=${MYCNF} ${OPTIONS} < ${SQL_DIR}audit_tables.sql >> ${LOG_FILE}

exit $?

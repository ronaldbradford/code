#!/bin/sh
[ -z "${MYCNF}" ] && MYCNF="/mysql/etc/my.cnf"

if [ `grep "^server.id" ${MYCNF} | head -1 | cut -d'=' -f2 | sed -e "s/ //g;s/#.*$//"` = "999" ]
then
  service mysql stop
  rm -f /mysql/data/auto.cnf
  SERVER_ID=`/sbin/ifconfig eth0 | grep "inet addr" | cut -d: -f2 | sed "s/ .*$//" | cut -d. -f4`
  echo "MySQL server-id=${SERVER_ID}"
  sed -ie "s/^server-id.*$/server-id=${SERVER_ID}/" $MYCNF
  service mysql start
  mysql -e "RESET MASTER"
fi

exit 0

#/bin/sh

[ -f "/etc/redhat-release" ] && REDHAT=Y

NEW_HOSTNAME=$1
[ -z "${NEW_HOSTNAME}" ] && echo "ERROR: $0 <new-hostname>" && exit 1

NEWRELIC="/etc/init.d/newrelic-sysmond"
if [ ! -z "${REDHAT}" ]
then
  sudo hostname ${NEW_HOSTNAME}
  sudo sed -i -e "s/^HOSTNAME.*$/HOSTNAME=${NEW_HOSTNAME}/" /etc/sysconfig/network
  sudo service network restart
  [ -f "${NEWRELIC}" ] && ${NEWRELIC} restart
  hostname
fi

exit 0

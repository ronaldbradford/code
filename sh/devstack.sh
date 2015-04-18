#!/bin/sh

[ `id -u` -ne 0 ] && echo "Must be run as 'root'" && exit 0

# This creates default group of same username
# This creates install in /home/stack
NEW_USER="stack"
[ `grep ${NEW_USER} /etc/passwd | wc -l` -eq 0 ] && useradd -s /bin/bash -m ${NEW_USER}
NEW_USER_SUDO_FILE="/etc/sudoers.d/${NEW_USER}"
[ ! -s ${NEW_USER_SUDO_FILE} ] && umask 226 && echo "${NEW_USER} ALL=(ALL) NOPASSWD: ALL" > ${NEW_USER_SUDO_FILE}
ls -l ${NEW_USER_SUDO_FILE}

sudo su - stack -c "git clone https://git.openstack.org/openstack-dev/devstack"

cd /tmp
LOCAL_CONF="local.conf"
IP=`/sbin/ifconfig eth0 | grep "inet addr" | cut -d: -f2 | sed -e "s/ .*//"`

echo "[[local|localrc]]
ADMIN_PASSWORD=passwd
DATABASE_PASSWORD=\$ADMIN_PASSWORD
RABBIT_PASSWORD=\$ADMIN_PASSWORD
SERVICE_PASSWORD=\$ADMIN_PASSWORD
SERVICE_TOKEN=a682f596-76f3-11e3-b3b2-e716f9080d50
HOST_IP=${IP}" > ${LOCAL_CONF}

cat ${LOCAL_CONF}

chown ${NEW_USER}:${NEW_USER} local.conf
mv ${LOCAL_CONF} ~${NEW_USER}/devstack

exit 0

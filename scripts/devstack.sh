#!/bin/sh

[ `id -u` -ne 0 ] && echo "Must be run as 'root'" && exit 0

# This creates default group of same username
# This creates install in /home/stack
NEW_USER="stack"
[ `grep ${NEW_USER} /etc/passwd | wc -l` -eq 0 ] && useradd -s /bin/bash -m ${NEW_USER}
NEW_USER_SUDO_FILE="/etc/sudoers.d/${NEW_USER}"
[ ! -s ${NEW_USER_SUDO_FILE} ] && umask 226 && echo "${NEW_USER} ALL=(ALL) NOPASSWD: ALL" > ${NEW_USER_SUDO_FILE}
ls -l ${NEW_USER_SUDO_FILE}

[ -z `which git` ] && sudo apt-get install -y git-core

APT_CACHE_CONF="/etc/apt/apt.conf.d/90-apt-cacher"
[ ! -f "${APT_CACHE_CONF}" ] && echo 'Acquire::http::Proxy "http://192.168.1.50:3142";' | tee ${APT_CACHE_CONF}

sudo su - stack -c "git clone https://git.openstack.org/openstack-dev/devstack"
sudo su - stack -c "git config --global user.name 'Ronald Bradford'; git config --global user.email me@ronaldbradford.com"

cd /tmp
LOCAL_CONF="local.conf"
IP=`/sbin/ifconfig eth1 | grep "inet addr" | cut -d: -f2 | sed -e "s/ .*//"`

echo "[[local|localrc]]
ADMIN_PASSWORD=passwd
DATABASE_PASSWORD=\$ADMIN_PASSWORD
RABBIT_PASSWORD=\$ADMIN_PASSWORD
SERVICE_PASSWORD=\$ADMIN_PASSWORD
SERVICE_TOKEN=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
HOST_IP=${IP}
LOG_COLOR=False
#OFFLINE=True
#RECLONE=True
#enable_plugin magnum https://github.com/openstack/magnum
#PUBLIC_INTERFACE=eth1
#VOLUME_BACKING_FILE_SIZE=20G" > ${LOCAL_CONF}

cat ${LOCAL_CONF}

echo "#!/bin/sh
sudo iptables -t nat -A POSTROUTING -o br-ex -j MASQUERADE" > local.sh

chown ${NEW_USER}:${NEW_USER} local.conf local.sh
chmod 755 local.sh
mv ${LOCAL_CONF} /home/${NEW_USER}/devstack

exit 0

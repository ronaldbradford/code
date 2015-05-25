#!/bin/sh
[ `id -u` -ne 0 ] && echo "ERROR: This script must be run as root" && exit 1
VERSION=`grep DISTRIB_CODENAME /etc/lsb-release 2>/dev/null | cut -d'=' -f2`
[ -z "${VERSION}" ] && echo "ERROR: Unable to get Ubuntu Version, other distros not yet supported." && exit 1
gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
gpg -a --export CD2EFD2A | sudo apt-key add -
if [ `grep repo.percona.com /etc/apt/sources.list | wc -l` -eq 0 ]
then
  echo "Adding Percona repos"
  echo "deb http://repo.percona.com/apt ${VERSION} main
deb-src http://repo.percona.com/apt ${VERSION} main" >> /etc/apt/sources.list
fi

apt-get update
apt-cache search xtrabackup
apt-get install -y percona-xtrabackup

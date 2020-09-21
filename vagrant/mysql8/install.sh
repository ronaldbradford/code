#!/usr/bin/env /bin/bash

# Use TDD for verification of installation
sudo yum install -y http://rpmfind.net/linux/fedora/linux/releases/30/Everything/x86_64/os/Packages/b/bats-1.1.0-2.fc30.noarch.rpm
type -P bats
bats -version

# Install MySQL 8
sudo rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
sudo sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
sudo yum -y --enablerepo=mysql80-community install mysql-community-server
rpm -qa mysql-community-server

# Complete first time setup
sudo systemctl start mysqld.service
PASSWD=$(sudo grep "A temporary password" /var/log/mysqld.log | sed -e "s/^.*: //")
# Because openssl does not always give you a special character
# TODO: create mylogin.cnf which is more obfuscated
if [ ! -f "/root/.my.cnf" ]; then
  NEWPASSWD="$(openssl rand -base64 24)+"
  mysql -uroot -p${PASSWD} -e "ALTER USER USER() IDENTIFIED BY '${NEWPASSWD}'" --connect-expired-password
  echo "[mysql]
user=root
password='$NEWPASSWD'" | sudo tee -a /root/.my.cnf
fi 

# Installation checks
sudo mysql -NBe "SHOW GRANTS"
systemctl status mysqld.service
ps -ef | grep mysqld
pidof mysqld

# Run TDD
bats /vagrant/mysql8.bats

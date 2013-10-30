#!/bin/sh


[ -z "${LICENSE_KEY}" ] && echo "USAGE:  LICENSE_KEY=xxxx  $0" && exit 0

rpm -Uvh http://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
yum install -y newrelic-sysmond
nrsysmond-config --set license_key=${LICENSE_KEY}
/etc/init.d/newrelic-sysmond start

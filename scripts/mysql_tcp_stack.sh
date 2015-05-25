#!/bin/sh


[ -z "${DIGESTER}" ] && DIGESTER="pt-query-digest"
[ -z `which ${DIGESTER} 2>/dev/null` ] && echo "'${DIGESTER}' not found. Try wget http://percona.com/get/${DIGESTER}; chmod +x ${DIGESTER}; sudo mv ${DIGESTER} /usr/local/bin" && exit 1

TCPDUMP=/usr/sbin/tcpdump
[ -z `which ${TCPDUMP} 2>/dev/null` ] && echo "'${TCPDUMP}' not found. Try sudo yum install -y tcpdump" && exit 2


# Need a check also for
# sudo sum install -y perl-Time-HiRes

export DT=`date +%y%m%d.%H%M%S`  
sudo ${TCPDUMP} -i any port 3306 -s 65535  -x -nn -q -tttt -c 10000 > ${DT}.tcp  
${DIGESTER} --type tcpdump --limit 100%:50 ${DT}.tcp > ${DT}.out
gzip ${DT}.tcp &
more ${DT}.out

exit 0

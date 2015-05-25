#/bin/sh

FILE=$1
[ -z "${FILE}" ] && echo "USAGE: $0 <file>" && exit 1


SERVERS="servers"
BASENAME=`basename ${FILE}`

parallel-scp -h ${SERVERS} ${FILE} /tmp/${BASENAME}  
parallel-ssh -i -h servers -x "-t -t" "sudo mv /tmp/${BASENAME} /usr/local/bin"


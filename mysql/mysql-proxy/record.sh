#!/bin/sh
mkdir -p record
# Accept traffic on default port of 4040
# Redirect traffic to MySQL default port of 3306
# To redirect to different server
#    MYSQL_SERVER="--proxy-backend-addresses=server.rds.amazonaws.com:3306"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:`pwd`/lib ./libexec/mysql-proxy --proxy-lua-script=record.lua  ${MYSQL_SERVER} > tmp.log 2>&1 &

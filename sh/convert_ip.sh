#!/bin/sh
echo "$1" | awk 'BEGIN {FS="."} {print lshift($1,24)+lshift($2,16)+lshift($3,8)+$4}'

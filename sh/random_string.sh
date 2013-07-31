#!/bin/sh
# There are several ways to get random content from files like 
# rl, random-lines, sort --random-sort, but many are not installed
#
# This is low tech way to get a string of random characters

LENGTH=$1
[ -z "${LENGTH}" ] && LENGTH=14
LENGTH=`expr ${LENGTH} \/ 2`

ls /etc | cut -c3 | perl -n -e 'print if (rand() < 0.6)' | perl -n -e 'print if (rand() < 0.6)' | head -${LENGTH} | awk '{printf("%s%d",$1,int(9*rand()))}'

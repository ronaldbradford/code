#!/bin/sh

# Format a XML document with one element per line for simple string management
[ $# -eq 0 ] && echo "$0 <files>" && exit 1
cat $* | sed -e "s/<[^/]/\\
&/g;s/><\//>\\
<\//g"



#!/bin/sh

# remove all <html> tags from text
[ $# -eq 0 ] && echo "$0 <files>" && exit 1
cat $* | sed -e "s/<[^>]*>//g"


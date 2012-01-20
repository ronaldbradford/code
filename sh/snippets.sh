

# Initialize output redirection
#
exec >> ${LOGFILE}              # Redirect STDOUT to our log file
exec 2>&1                       # Redirect STDERR to same log file as STDOUT


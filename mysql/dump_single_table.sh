#!/bin/sh
mysqldump -uroot -p --skip-lock-tables --no-create-info --complete-insert --skip-extended-insert --skip-add-locks --skip-quote-names --skip-set-charset --skip-disable-keys $*

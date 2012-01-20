#!/bin/sh
mysqladmin -uroot -p -r -i 1 extended-status | grep -v " | 0 "

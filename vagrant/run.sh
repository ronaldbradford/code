#!/usr/bin/env /bin/bash
set -euo pipefail

[ $# -ne 1 ] && echo "USAGE: $0 <vm>" && exit 1

VM=$1
cd $VM
vagrant validate
vagrant up
vagrant ssh-config > .config
cat .config
ssh -F .config ${VM} hostname

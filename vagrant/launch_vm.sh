#!/usr/bin/env /bin/bash
set -euo pipefail

[ $# -ne 1 ] && echo "USAGE: $0 <vm>" && exit 1

VM=$1
[ ! -d "${VM}" ] && echo "ERROR: VM directory '${VM}' not found" && exit 1
cd $VM
vagrant validate
vagrant up
vagrant ssh-config > config
cat config

# We don't care if a prior vagrant SSH config exists, overwrite it
mkdir -p ${HOME}/.ssh/vagrant.d
cp config ${HOME}/.ssh/vagrant.d/${VM}

# Verify SSH access
ssh ${VM} hostname
#ssh -F config ${VM} hostname

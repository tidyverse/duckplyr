#!/bin/bash

# A script to provision a fresh machine on OrbStack and to run clone.sh

set -e
set -x

cd $(dirname $0)

if orbctl list | grep -q duckplyr; then
  orbctl delete -f duckplyr
fi
orbctl create -a amd64 ubuntu:22.04 duckplyr
ssh duckplyr@orb 'bash -s' < clone.sh

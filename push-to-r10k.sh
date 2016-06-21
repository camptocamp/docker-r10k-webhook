#!/bin/bash

REF="$1"

export PATH=/opt/puppetlabs/bin:$PATH

if [[ $REF =~ 'refs/heads/' ]]; then
  mco r10k sync
else
  echo "r10k skipping $REF"
fi

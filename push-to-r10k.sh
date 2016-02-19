#!/bin/bash

REF="$1"

export PATH=/opt/puppetlabs/bin:$PATH

if [[ $REF =~ 'refs/heads/' ]]; then
  branch=$(cut -d/ -f3 <<<"${REF}")
  mco r10k deploy $branch
else
  echo "r10k skipping $REF"
fi

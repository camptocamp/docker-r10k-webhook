#!/bin/bash

REF="$1"

export PATH=/opt/puppetlabs/bin:$PATH

if [[ $REF =~ 'refs/heads/' ]]; then
  branch=$(cut -d/ -f3 <<<"${REF}")
  r10k deploy environment $branch -p
else
  echo "r10k skipping $REF"
fi

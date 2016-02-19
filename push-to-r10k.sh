#!/bin/bash

export PATH=/opt/puppetlabs/bin:$PATH
while read oldrev newrev refname; do
  # R10K
  if [[ $refname =~ 'refs/heads/' ]]; then
    branch=$(git rev-parse --symbolic --abbrev-ref $refname)
    mco r10k deploy $branch
  else
    echo "r10k skipping $refname"
  fi
done

#!/bin/bash

mkdir -p /etc/puppetlabs/r10k
cat << EOF > /etc/puppetlabs/r10k/r10k.yaml
# The location to use for storing cached Git repos
:cachedir: '/opt/puppetlabs/r10k/cache'

# A list of git repositories to create
:sources:
  # This will clone the git repository and instantiate an environment per
  # branch in /etc/puppetlabs/code/environments
  :main:
    remote: '${REMOTE}'
    basedir: '/etc/puppetlabs/code/environments'
EOF

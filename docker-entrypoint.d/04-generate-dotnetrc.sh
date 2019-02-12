#!/bin/bash
set -e

if test -n "${GITHUB_TOKEN}"; then

# Retrieve GITHUB_USER from GITHUB_TOKEN
GITHUB_USER=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/user | sed -n '/ *"login": "\(.*\)",$/ s//\1/p')

if test -n "${GITHUB_USER}" && test -n "${GITHUB_TOKEN}"; then
  cat << EOF > ~/.netrc
machine github.com
login ${GITHUB_USER}
password ${GITHUB_TOKEN}
machine api.github.com
login ${GITHUB_USER}
password ${GITHUB_TOKEN}
EOF
fi

fi

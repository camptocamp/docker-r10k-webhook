#!/bin/bash

if test -n "${RSA_PRIVATE_KEY}"; then
  echo -e "${RSA_PRIVATE_KEY}" > /root/.ssh/id_rsa
  chmod 0600 /root/.ssh/id_rsa
fi

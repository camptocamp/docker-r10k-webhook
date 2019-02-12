#!/bin/bash

DIR=/docker-entrypoint.d

if [[ -d "$DIR" ]]
then
  /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
fi

umask 0002
exec /nss_wrapper.sh "$@"

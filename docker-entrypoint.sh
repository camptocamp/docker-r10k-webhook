#!/bin/bash

DIR=/docker-entrypoint.d

if [[ -d "$DIR" ]]
then
  /bin/run-parts --verbose --regex '\.(sh|rb)$' "$DIR"
fi

exec /go/bin/webhook -hooks /etc/webhook/r10k.yaml.tmpl -template -verbose "$@"

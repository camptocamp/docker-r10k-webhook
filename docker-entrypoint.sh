#!/bin/sh

sed -i "s/%{HOOKS_SECRET}/${HOOKS_SECRET}/g" /etc/webhook/*.json

exec /go/bin/webhook -hooks /etc/webhook/*.json -verbose

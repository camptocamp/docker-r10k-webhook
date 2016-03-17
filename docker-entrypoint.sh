#!/bin/sh

sed -i "s/%{HOOKS_SECRET}/${HOOKS_SECRET}/g" /etc/webhook/*.json
sed -i -e "s/^\(plugin.activemq.pool.1.password = \).*$/\1${MCOLLECTIVE_PASSWORD}/" /etc/puppetlabs/mcollective/client.cfg

exec /go/bin/webhook -hooks /etc/webhook/*.json -verbose

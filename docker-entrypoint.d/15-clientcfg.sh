#!/bin/sh

# Setup client.cfg
cat << EOF >> /etc/puppetlabs/mcollective/client.cfg
plugin.ssl_server_public = /etc/puppetlabs/mcollective/ssl/server-public.pem

plugin.ssl_client_public = /etc/puppetlabs/mcollective/ssl/${MCOLLECTIVE_CLIENT_USER}.pem
plugin.ssl_client_private = /etc/puppetlabs/mcollective/ssl/${MCOLLECTIVE_CLIENT_USER}-private.pem
EOF

mkdir -p /etc/puppetlabs/mcollective/ssl

# Dump private key
echo -e "${MCOLLECTIVE_CLIENT_PRIVATE_KEY}" > /etc/puppetlabs/mcollective/ssl/${MCOLLECTIVE_CLIENT_USER}-private.pem

# Generate public X509 key
ssh-keygen -f /etc/puppetlabs/mcollective/ssl/${MCOLLECTIVE_CLIENT_USER}-private.pem -e -m pem > /etc/puppetlabs/mcollective/ssl/${MCOLLECTIVE_CLIENT_USER}.pem

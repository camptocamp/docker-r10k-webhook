#!/bin/bash

touch /etc/puppetlabs/code/environments/r10k-initializing.lock

r10k deploy environment -pv

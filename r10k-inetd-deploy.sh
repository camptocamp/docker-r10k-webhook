#!/bin/bash

getent hosts r10k|cut -f1 -d' '|while host; do
  rsh $host r10k deploy environment $1 -p
done

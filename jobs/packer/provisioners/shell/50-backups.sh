#!/bin/sh -e

cd /usr/local/bin

curl -L https://github.com/restic/restic/releases/download/v0.11.0/restic_0.11.0_linux_amd64.bz2 | \
  bunzip2 > restic
chmod +x restic

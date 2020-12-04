#!/bin/sh -e

# Install creature comforts
if type dnf &> /dev/null; then
  dnf install -y curl fish git-core htop micro ncdu
fi

useradd -G wheel -s /usr/bin/fish pandentia

# Set up SSH
mkdir -p /home/pandentia/.ssh
curl --fail https://github.com/SapphicCode.keys -o /home/pandentia/.ssh/authorized_keys
chmod -R u=rwX,go= /home/pandentia/.ssh
chown -R pandentia /home/pandentia

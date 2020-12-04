#!/bin/sh -e

cd /usr/local/bin

# Install Vault
curl https://releases.hashicorp.com/vault/1.6.0/vault_1.6.0_linux_amd64.zip -o bin.zip
unzip bin.zip
rm bin.zip

systemctl enable vault.service

# Install Caddy
curl -L https://github.com/caddyserver/caddy/releases/download/v2.2.1/caddy_2.2.1_linux_amd64.tar.gz | \
  tar -zxv --exclude=README.md --exclude=LICENSE

systemctl enable caddy.service

# Set up firewall
firewall-cmd --zone=public --permanent --add-service=http --add-service=https

# Add fstab entry
echo "UUID=872929f3-0e94-4ff0-8de4-829824dbf615 /var/lib/vault xfs defaults 0 0" >> /etc/fstab

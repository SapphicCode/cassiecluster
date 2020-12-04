locals {
  hcloud_token = vault("cassandra/data/terraform", "hcloud")
  do_token = vault("cassandra/data/terraform", "digitalocean")
}

source "hcloud" "centos" {
  token = local.hcloud_token

  image = "centos-8"
  server_type = "cx11"
  location = "hel1"

  ssh_username = "root"
}

source "digitalocean" "centos" {
  api_token = local.do_token

  image = "centos-8-x64"
  size = "s-1vcpu-1gb"
  region = "ams3"

  ssh_username = "root"
}

build {
  name = "security"

  sources = [
    # "hcloud.centos",
    "digitalocean.centos",
  ]

  provisioner "file" {
    source = "../../configs/systemd/units/"
    destination = "/etc/systemd/system/"
  }

  provisioner "shell" {
    inline = [
      "systemctl daemon-reload",
      "mkdir -p /etc/vault.d /etc/caddy",
    ]
  }

  provisioner "file" {
    source = "../../configs/vault/vault.hcl"
    destination = "/etc/vault.d/vault.hcl"
  }
  provisioner "file" {
    source = "../../configs/vault/Caddyfile"
    destination = "/etc/caddy/Caddyfile"
  }

  provisioner "shell" {
    scripts = [
      "./provisioners/shell/10-centos.sh",
      "./provisioners/shell/20-cassandra.sh",
      "./provisioners/shell/90-security.sh",
      "./provisioners/shell/99-cleanup.sh",
    ]
  }
}

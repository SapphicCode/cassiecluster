data "http" "ssh_cassandra" {
  url = "https://github.com/SapphicCode.keys"
}

resource "digitalocean_droplet" "security" {
  name   = "security-gateway"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  image  = "fedora-32-x64"
  user_data = templatefile(
    "../configs/cloud-init/cluster.yml",
    { keys = jsonencode(split("\n", trimspace(data.http.ssh_cassandra.body))) }
  )
  volume_ids = [digitalocean_volume.vault.id]
}

resource "digitalocean_volume" "vault" {
  name                    = "vault"
  region                  = "ams3"
  size                    = 1
  initial_filesystem_type = "xfs"
}

locals {
  do_instances = {
    security = digitalocean_droplet.security,
  }
}

resource "cloudflare_record" "rdns_v4_do" {
  zone_id = cloudflare_zone.servers.id
  type    = "A"
  name    = each.key
  value   = each.value.ipv4_address

  for_each = local.do_instances
}

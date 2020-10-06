provider "hcloud" {}

// VPCs

resource "hcloud_server" "mistress" {
  name        = "cassiepool-mistress"
  server_type = "cpx11"
  location    = "hel1"
  image       = "ubuntu-18.04" // ignore this, just the original image
}

resource "hcloud_server" "db" {
  name        = "cassiedb"
  server_type = "cpx11"
  location    = "hel1"
  image       = "ubuntu-20.04" // see above
}

resource "hcloud_server" "ns2" {
  name        = "dns-ns2"
  server_type = "cx11"
  location    = "nbg1"
  image       = "ubuntu-20.04"
  lifecycle {
    ignore_changes = [image]
  }
}

// DNS

locals {
  instances = [
    hcloud_server.mistress,
    hcloud_server.db,
    hcloud_server.ns2,
  ]
}

// v4
resource "hcloud_rdns" "v4" {
  server_id  = local.instances[count.index].id
  ip_address = local.instances[count.index].ipv4_address
  dns_ptr    = "${local.instances[count.index].name}.servers.pandentia.sys.qcx.io"

  count = length(local.instances)
}

resource "cloudflare_record" "rdns_v4_hcloud" {
  zone_id = cloudflare_zone.servers.id
  type    = "A"
  name    = local.instances[count.index].name
  value   = local.instances[count.index].ipv4_address

  count = length(local.instances)
}

// v6
resource "hcloud_rdns" "v6" {
  server_id  = local.instances[count.index].id
  ip_address = local.instances[count.index].ipv6_address
  dns_ptr    = "${local.instances[count.index].name}.servers.pandentia.sys.qcx.io"

  count = length(local.instances)
}

resource "cloudflare_record" "rdns_v6_hcloud" {
  zone_id = cloudflare_zone.servers.id
  type    = "AAAA"
  name    = local.instances[count.index].name
  value   = local.instances[count.index].ipv6_address

  count = length(local.instances)
}

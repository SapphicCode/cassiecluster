// VPCs

locals {
  helsinki = {
    dc = "fl-helsinki"
    tz = "Europe_Helsinki"
  }
  nuremberg = {
    dc = "de-nuremberg"
    tz = "Europe_Berlin"
  }
}

resource "hcloud_server" "mistress" {
  name        = "cassiepool-mistress"
  server_type = "cpx11"
  location    = "hel1"
  image       = "ubuntu-18.04" // ignore this, just the original image
  labels = merge(local.helsinki, {
    lighthouse = true
  })
}

resource "hcloud_server" "db" {
  name        = "cassiedb"
  server_type = "cpx11"
  location    = "hel1"
  image       = "ubuntu-20.04" // see above
  labels      = local.helsinki
}

resource "hcloud_server" "ns2" {
  name        = "dns-ns2"
  server_type = "cx11"
  location    = "nbg1"
  image       = "ubuntu-20.04"
  labels      = local.nuremberg
  lifecycle {
    ignore_changes = [image]
  }
}

// DNS

locals {
  instances = {
    mistress = hcloud_server.mistress,
    cassiedb = hcloud_server.db,
    dns-ns2  = hcloud_server.ns2,
  }
}

resource "cloudflare_record" "alias_mistress" {
  zone_id = cloudflare_zone.servers.id
  type    = "CNAME"
  name    = "cassiepool-mistress"
  value   = "mistress.servers.pandentia.sys.qcx.io"
}

// v4
resource "hcloud_rdns" "v4" {
  server_id  = each.value.id
  ip_address = each.value.ipv4_address
  dns_ptr    = "${each.key}.servers.pandentia.sys.qcx.io"

  for_each = local.instances
}

resource "cloudflare_record" "rdns_v4_hcloud" {
  zone_id = cloudflare_zone.servers.id
  type    = "A"
  name    = each.key
  value   = each.value.ipv4_address

  for_each = local.instances
}

// v6
resource "hcloud_rdns" "v6" {
  server_id  = each.value.id
  ip_address = each.value.ipv6_address
  dns_ptr    = "${each.key}.servers.pandentia.sys.qcx.io"

  for_each = local.instances
}

resource "cloudflare_record" "rdns_v6_hcloud" {
  zone_id = cloudflare_zone.servers.id
  type    = "AAAA"
  name    = each.key
  value   = each.value.ipv6_address

  for_each = local.instances
}

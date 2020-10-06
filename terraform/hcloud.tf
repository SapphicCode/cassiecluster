provider "hcloud" {}

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

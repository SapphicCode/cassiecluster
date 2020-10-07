resource "cloudflare_zone" "beelen" {
  zone = "beelen.one"
}

resource "cloudflare_zone" "servers" {
  zone = "servers.pandentia.sys.qcx.io"
}

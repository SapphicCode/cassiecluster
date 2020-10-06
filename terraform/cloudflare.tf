provider "cloudflare" {}

resource "cloudflare_zone" "beelen" {
  zone = "beelen.one"
}

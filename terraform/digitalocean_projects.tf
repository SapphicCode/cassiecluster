resource "digitalocean_project" "cassiecluster" {
  name        = "Cassiecluster"
  environment = "Production"
  resources = [
    digitalocean_droplet.security.urn,
    digitalocean_volume.vault.urn,
  ]
}

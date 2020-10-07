resource "google_kms_key_ring" "cluster" {
  name     = "cassiecluster"
  location = "europe"
}

resource "google_kms_crypto_key" "vault" {
  key_ring = google_kms_key_ring.cluster.id
  name     = "vault"
  purpose  = "ENCRYPT_DECRYPT"
}

resource "google_kms_key_ring" "cluster" {
  name     = "cassiecluster"
  location = "europe"
}

resource "google_kms_crypto_key" "vault" {
  key_ring = google_kms_key_ring.cluster.id
  name     = "vault"
  purpose  = "ENCRYPT_DECRYPT"
}

locals {
  vault_roles = [
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
    "roles/viewer",
  ]
}

resource "google_kms_crypto_key_iam_member" "vault" {
  crypto_key_id = google_kms_crypto_key.vault.id
  role          = local.vault_roles[count.index]
  member        = "serviceAccount:${google_service_account.vault.email}"

  count = length(local.vault_roles)
}

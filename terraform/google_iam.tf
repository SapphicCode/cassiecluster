resource "google_service_account" "vault" {
  account_id   = "hashicorp-vault"
  display_name = "Vault"
}

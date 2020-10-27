resource "vault_approle_auth_backend_role" "terraform" {
  role_name = "terraform"

  token_policies = ["ci"]
  token_ttl      = 30 * 60
}

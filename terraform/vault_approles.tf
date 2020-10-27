// CI tooling
resource "vault_approle_auth_backend_role" "terraform" {
  role_name = "terraform"

  token_policies = [
    vault_policy.ci.name,
  ]
  token_ttl = 30 * 60
}

// Personal admin roles
resource "vault_approle_auth_backend_role" "iphone" {
  role_name = "iphone"

  token_policies = [
    vault_policy.admin.name,
  ]
  token_ttl = 60
}

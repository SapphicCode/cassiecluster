resource "vault_policy" "admin" {
  name   = "admin"
  policy = file("../configs/vault/policies/admin.hcl")
}

resource "vault_policy" "ci" {
  name   = "ci"
  policy = file("../configs/vault/policies/ci.hcl")
}

resource "vault_policy" "terraform" {
  name   = "terraform"
  policy = file("../configs/vault/policies/terraform.hcl")
}

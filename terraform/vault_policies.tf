resource "vault_policy" "ci" {
  name   = "ci"
  policy = file("../configs/vault/policies/ci.hcl")
}

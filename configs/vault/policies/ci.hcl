// Allow creation of sub-tokens
path "auth/token/create" {
  capabilities = ["update"]
}

// CI:
// Allow modification of policies
path "sys/policies/acl/+" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
// Allow modification of approles
path "auth/approle/role/*" {
  capabilities = ["create", "read", "update", "delete"]
}

// Secrets:
// Allow access to Terraform secrets
path "terraform/+" {
  capabilities = ["read"]
}
// Allow access to cluster secrets
path "cassiecluster/+" {
  capabilities = ["read"]
}

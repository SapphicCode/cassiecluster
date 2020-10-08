// Allow creation of sub-tokens
path "auth/token/create" {
  capabilities = ["update"]
}

// Allow access to Terraform secrets
path "terraform/+" {
  capabilities = ["read"]
}

// Allow access to cluster secrets
path "cassiecluster/+" {
  capabilities = ["read"]
}

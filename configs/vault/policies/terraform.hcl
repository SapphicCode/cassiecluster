// Allow creation of sub-tokens
path "auth/token/create" {
  capabilities = ["update"]
}

// Allow modification of policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
// Allow modification of approles
path "auth/approle/role/*" {
  capabilities = ["create", "read", "update", "delete"]
}

// Allow read access to Terraform secrets
path "terraform/data/*" {
  capabilities = ["read"]
}
path "cassandra/data/terraform" {
  capabilities = ["read"]
}
path "aws/cassandra/sts/terraform" {
  capabilities = ["read"]
}
// Allow write access to cluster secrets
path "cassiecluster/*" {
  capabilities = ["create", "read", "update", "delete"]
}

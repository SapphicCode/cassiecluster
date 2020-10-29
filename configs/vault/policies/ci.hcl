// Allow read access to cluster secrets
path "cassiecluster/*" {
  capabilities = ["read"]
}

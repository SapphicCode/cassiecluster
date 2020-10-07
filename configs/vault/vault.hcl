listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = true
}

storage "consul" {}
seal "transit" {
  // address = $VAULT_ADDR
  // token = $VAULT_TOKEN
  mount_path = "transit/"
  key_name = "vault"
}

ui = true

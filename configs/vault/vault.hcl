listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = true
}

storage "file" {
  path = "/var/lib/vault"
}

ui = true

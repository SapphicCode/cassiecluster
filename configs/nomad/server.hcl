server {
  enabled = true
  bootstrap_expect = {{ bootstrap.nomad }}
}

client {
  node_class = "manager" // how convenient client.hcl comes before server.hcl
}

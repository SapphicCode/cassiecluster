data_dir = "/var/lib/nomad"

bind_addr = "{{ GetInterfaceIP \"nebula1\" }}"
#addresses {
#  http = "127.0.0.1"
#}
#advertise {
#  http = "127.0.0.1"
#}

plugin "docker" {
  config {
    allow_caps = ["ALL"]
    volumes {
      enabled = true
    }
  }
}

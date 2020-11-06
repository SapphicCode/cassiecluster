job "knot" {
  datacenters = ["fi-helsinki", "de-nuremberg"]
  type = "service"
  priority = 100

  update {
    auto_revert = true
    healthy_deadline = "1m"
  }

  group "ns1" {
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "mistress"
    }
    service {
      check {
        type = "tcp"
        port = "dns"
        interval = "10s"
        timeout = "2s"

        check_restart {
          limit = 2
          grace = "30s"
        }
      }
    }
    network {
      port "dns" {
        to = 53
        static = 53
        host_network = "public"
      }
    }
    task "knot" {
      driver = "docker"
      config {
        image = "cznic/knot:latest"

        command = "knotd"

        volumes = [
          "/srv/docker/cassandra/knot/mistress:/storage"
        ]
        ports = ["dns"]
      }
      resources {
        memory = 64
      }
    }
  }

  group "ns2" {
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "dns-ns2"
    }
    service {
      check {
        type = "tcp"
        port = "dns"
        interval = "10s"
        timeout = "2s"

        check_restart {
          limit = 2
          grace = "30s"
        }
      }
    }
    network {
      port "dns" {
        to = 53
        static = 53
        host_network = "public"
      }
    }
    task "knot" {
      driver = "docker"
      config {
        image = "cznic/knot:latest"

        command = "knotd"

        volumes = [
          # "/srv/docker/cassandra/knot/ns2:/storage"
          "/etc/knot:/storage"
        ]
        ports = ["dns"]
      }
      resources {
        memory = 64
      }
    }
  }
}

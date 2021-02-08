job "databases" {
  type = "service"
  priority = 80

  datacenters = ["fi-helsinki"]
  constraint {
    attribute = "${attr.unique.hostname}"
    value = "cassiedb"
  }

  group "influx" {
    task "daemon" {
      driver = "docker"
      config {
        image = "quay.io/influxdb/influxdb:2.0.0-beta"

        ports = ["http"]

        volumes = [
          "/srv/db/influx:/root/.influxdbv2"
        ]
      }

      resources {
        cpu = 100
        memory = 300
      }
    }
    network {
      port "http" {
        static = 9999
        to = 9999
        host_network = "nebula"
      }
    }
    service {
      name = "influx"

      port = "http"

      check {
        type = "http"
        path = "health"
        interval = "1s"
        timeout = "2s"

        check_restart {
          limit = 2
          grace = "60s"
        }
      }
    }
  }
}

job "homebridge" {
  datacenters = ["home"]
  type = "service"

  group "homebridge" {
    task "homebridge" {
      driver = "docker"
      config {
        image = "oznu/homebridge:latest"

        network_mode = "host"
        volumes = [
          "/var/lib/homebridge:/homebridge"
        ]
      }
      env {
        TZ = "Europe/Amsterdam"
        HOMEBRIDGE_CONFIG_UI = "1"
        HOMEBRIDGE_CONFIG_UI_PORT = "8080"
      }
      resources {
        cpu = 100
        memory = 256
      }
    }
  }

  group "mqtt" {
    service {
      name = "mqtt"
      port = "mqtt"
      check {
        type = "tcp"
        port = "mqtt"
        interval = "10s"
        timeout = "2s"
      }
    }
    network {
      port "mqtt" {
        static = 1883
        to = 1883
        host_network = "home"
      }
    }
    task "mosquitto" {
      driver = "docker"
      config {
        image = "eclipse-mosquitto:latest"

        ports = ["mqtt"]
      }
      resources {
        cpu = 20
        memory = 32
      }
    }
  }
}
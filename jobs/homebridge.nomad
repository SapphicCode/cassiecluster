job "homebridge" {
  datacenters = ["home"]
  type = "service"

  group "homekit" {
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
        memory = 512
      }
    }
  }

  group "mqtt" {
    task "mosquitto" {
      driver = "docker"
      config {
        image = "eclipse-mosquitto:latest"

        network_mode = "host"
      }
      resources {
        cpu = 100
        memory = 64
      }
    }
  }
}
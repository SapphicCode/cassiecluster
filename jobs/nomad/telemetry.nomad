job "telemetry" {
  datacenters = ["fi-helsinki", "de-nuremberg", "home"]
  type = "system"
  priority = 1

  group "metrics" {
    task "telegraf" {
      driver = "docker"
      config {
        image = "telegraf:alpine"

        command = "telegraf"
        args = ["--config", "/local/telegraf.conf"]

        volumes = [
          "/:/host:ro"
        ]
        network_mode = "host"
      }
      env {
        HOST = "${attr.unique.hostname}"
        HOST_MOUNT_PREFIX = "/host"
        HOST_PROC = "/host/proc"
        HOST_SYS = "/host/sys"
        HOST_DEV = "/host/dev"
        HOST_ETC = "/host/etc"
        HOST_VAR = "/host/var"
      }

      artifact {
        source = "git::https://github.com/Pandentia/cassiecluster.git//configs/telegraf"
      }
      template {
        source = "local/telegraf.conf"
        destination = "local/telegraf.conf"
      }
      resources {
        cpu = 20
        memory = 64
      }
    }
  }
}
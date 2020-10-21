job "vault" {
  type = "service"
  priority = 90
  datacenters = ["fi-helsinki"]

  group "vault" {
    count = 1
    spread {
      attribute = "${node.unique.id}"
    }

    task "vault" {
      driver = "docker"

      config {
        image = "vault:1.5.3"
        args = ["vault", "server", "-config=${NOMAD_TASK_DIR}/vault.hcl"]

        cap_add = ["IPC_LOCK"]
        network_mode = "host"
        volumes = [
          "/srv/docker/cassandra/gcp/vault.json:/vault.json:ro"
        ]
      }

      artifact {
        source = "git::https://github.com/Pandentia/cassiecluster.git//configs/vault"
      }

      resources {
        memory = 256
      }
    }
  }
}

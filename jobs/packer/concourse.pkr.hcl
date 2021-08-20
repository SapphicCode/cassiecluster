locals {
  hcloud_token = vault("kv/cluster/data/concourse/phoenix/terraform", "hcloud")
}

source "hcloud" "ubuntu" {
  token = local.hcloud_token

  image = "ubuntu-20.04"
  server_type = "cx11"
  location = "hel1"

  ssh_username = "root"
}

build {
  name = "concourse"

  sources = [
    "hcloud.ubuntu"
  ]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y ansible ansible-galaxy"
    ]
  }
  provisioner "ansible-local" {
    playbook_file = "playbooks/50-concourse.yml"
    galaxy_file = "playbooks/galaxy.txt"
  }
}

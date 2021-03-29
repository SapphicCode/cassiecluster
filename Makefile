decrypt:
	sops -d secrets/openssh/id_ed25519 > configs/openssh/id_ed25519 && chmod u=rw,go= configs/openssh/id_ed25519
	sops -d secrets/ansible/cassandra.hcloud.yml > configs/ansible/inventory/cassandra.hcloud.yml

ansible:
	export ANSIBLE_CONFIG=configs/ansible/ansible.cfg
	ansible-playbook playbooks/*-*.yml

all:

#!/bin/sh

set -eux

export RCLONE_CONFIG=/tmp/rclone.conf

vault_request() {
  curl --fail --silent \
    -H "Content-Type: application/json" \
    -H "X-Vault-Token: ${VAULT_TOKEN-}" \
    -X "${1}" \
    -d "${3-}" \
    "${VAULT_ADDR}/v1/${2}"
}

# authenticate
auth=$(vault_request auth/approle/login "{\"role_id\": \"${VAULT_APPROLE_ID}\", \"secret_id\": \"${VAULT_APPROLE_SECRET}\"}")
VAULT_TOKEN=$(echo "${auth}" | jq .auth.client_token)
export VAULT_TOKEN

# fetch remotes
for key in $(echo "${VAULT_KEYS}" | tr , "\n"); do
  data=$(vault_request GET "${VAULT_KV}/data/${key}" | jq -c .data.data)
  rclone rc --loopback config/create --json "${data}"
done

rclone "$@"

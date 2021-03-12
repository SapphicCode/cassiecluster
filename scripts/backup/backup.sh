#!/usr/bin/env bash

set -eu

# shellcheck disable=SC1091
source /etc/vault.env

# Authenticate to Vault
auth_resp=$(
    curl -sf \
    -H "Content-Type: application/json" \
    -d "{\"role_id\": \"${VAULT_APPROLE_ID}\", \"secret_id\": \"${VAULT_APPROLE_SECRET}\"}" \
    "${VAULT_ADDR}/v1/auth/approle/login"
  )

VAULT_TOKEN=$(echo "${auth_resp}" | jq -r .auth.client_token)
export VAULT_TOKEN

# Get B2 credentials
setenv() {
  data=$(
    curl -sf \
    -H "X-Vault-Token: ${VAULT_TOKEN}" \
    "${VAULT_ADDR}/v1/${VAULT_KV}/data/${1}"
  )
  jq_statement=".data.data | to_entries | map(\"export ${2}_\\(.key | ascii_upcase)=\\\"\\(.value)\\\"\")[]"
  eval "$(echo "${data}" | jq -r "${jq_statement}")"
}

setenv b2/backup B2

# Get restic credentials
setenv restic RESTIC

# Run restic
restic backup \
  --exclude-caches \
  -e /var/lib/docker \
  -v --cache-dir /var/cache/restic \
  /etc /srv /var/lib /var/log /root /home

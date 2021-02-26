#!/usr/bin/env bash

shopt -s globstar
set -euxo pipefail

VAULT_TOKEN=$(vault write -field=token auth/approle/login role_id="${VAULT_APPROLE_ROLE}" secret_id "${VAULT_APPROLE_SECRET}")
export VAULT_TOKEN

for encrypted_file in **/*.transit; do
  plain_file=${encrypted_file%.*}
  vault write -field=plaintext transit/cluster/decrypt/automata "ciphertext=@${encrypted_file}" | base64 -d > "${plain_file}"
  touch --reference="${encrypted_file}" "${plain_file}"
  echo "${plain_file}"
done

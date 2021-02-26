#!/usr/bin/env bash

shopt -s globstar
set -euxo pipefail

for encrypted_file in **/*.transit; do
  plain_file=${encrypted_file%.*}
  vault write -field=plaintext transit/cluster/decrypt/automata "ciphertext=@${encrypted_file}" | base64 -d > "${plain_file}"
  touch -r "${encrypted_file}" "${plain_file}"
  echo "${plain_file}"
done

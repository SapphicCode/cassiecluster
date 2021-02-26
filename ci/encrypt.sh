#!/usr/bin/env bash

set -euxo pipefail

source_file="${1}"
encrypted_file="${1}.transit"

base64 "${source_file}" | vault write -field=ciphertext transit/cluster/encrypt/automata plaintext=- > "${encrypted_file}"
touch -r "${source_file}" "${encrypted_file}"
echo "${encrypted_file}"

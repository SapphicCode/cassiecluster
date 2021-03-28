# `rclone-vault`

`rclone-vault` bundles rclone and Hashicorp Vault together.

## Environment variables

- `VAULT_ADDR`: The Vault address to talk to
- `VAULT_APPROLE_ID`: The Vault AppRole ID to use
- `VAULT_APPROLE_SECRET`: The Vault AppRole secret to use
- `VAULT_KV`: The Vault KV v2 to access
- `VAULT_KEYS`: A comma-seperated list of Vault keys to pipe into rclone config/create

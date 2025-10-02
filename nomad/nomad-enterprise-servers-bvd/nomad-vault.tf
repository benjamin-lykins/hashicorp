#------------------------------------------------------------------------------
# Vault Secret Engine for Nomad
#------------------------------------------------------------------------------

resource "vault_mount" "nomad" {
  path        = "nomad-${var.nomad_region}/"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}

#------------------------------------------------------------------------------
# Gossip Encryption Key
#------------------------------------------------------------------------------

# Generate a 32-byte key (AES-256)
resource "random_id" "nomad_gossip_key" {
  byte_length = 32
}

resource "vault_kv_secret_v2" "nomad_gossip_key" {
  mount               = vault_mount.nomad.path
  name                = "secret"
  delete_all_versions = true
  data_json = jsonencode(
    {
      zip = "zap",
      foo = "bar"
    }
  )
}

#------------------------------------------------------------------------------
# Nomad Configuration Settings
#------------------------------------------------------------------------------

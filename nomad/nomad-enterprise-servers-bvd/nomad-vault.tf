# Just a quick note. I would like ot use more ephemeral resources, but at this point
# Not every resource supports it, yet. 
# Thinking specifically with the random resources. 


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
# Gossip Encryption Key -> Vault
#------------------------------------------------------------------------------

# Generate a 32-byte key (AES-256)
resource "random_id" "nomad_gossip_key" {
  byte_length = 32
}

# Store the key in Vault
resource "vault_kv_secret_v2" "nomad_gossip_key" {

  mount               = vault_mount.nomad.path
  name                = "gossip_key"
  delete_all_versions = true
  data_json = jsonencode(
    {
      key = random_id.nomad_gossip_key.b64_std
    }
  )
}

#------------------------------------------------------------------------------
# Bootstrap ACL Encryption Key -> Vault
#------------------------------------------------------------------------------

# Generate a UUID for the bootstrap ACL token
resource "random_uuid" "nomad_bootstrap_token" {}


# Store the token in Vault
resource "vault_kv_secret_v2" "nomad_bootstrap_token" {
  mount = vault_mount.nomad.path
  name  = "bootstrap_acl_token"
  data_json = jsonencode(
    {
      key = random_uuid.nomad_bootstrap_token.result
    }
  )
}

#------------------------------------------------------------------------------
# Nomad TLS 
#------------------------------------------------------------------------------

##TODO: Add support for cert generation via Vault PKI.

#------------------------------------------------------------------------------
# Nomad License 
#------------------------------------------------------------------------------
# Recommended licenses are stored in vault manually instead of adding in a tfvars file. 

data "vault_kv_secret_v2" "license" {
  mount = var.vault_license_mount
  name  = var.vault_license_secret
}

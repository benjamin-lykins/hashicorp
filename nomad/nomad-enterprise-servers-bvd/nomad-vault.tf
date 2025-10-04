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
  mount               = vault_mount.nomad.path
  name                = "bootstrap_acl_token"
  delete_all_versions = true
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


resource "vault_mount" "pki_int" {
  path                      = "pki-int-${var.nomad_region}"
  type                      = "pki"
  description               = "Intermediate PKI for Nomad cluster in ${var.nomad_region}"
  default_lease_ttl_seconds = 31536000 # 1 year
  max_lease_ttl_seconds     = 31536000
}


resource "vault_pki_secret_backend_intermediate_cert_request" "int_csr" {
  backend      = vault_mount.pki_int.path
  type         = "internal"
  common_name  = "Nomad Intermediate CA ${var.nomad_region}"
  organization = "LykinsCorp"
  key_type     = "rsa"
  key_bits     = 4096
}


resource "vault_pki_secret_backend_root_sign_intermediate" "signed_int" {
  backend     = "pki-root" # Root CA backend path
  csr         = vault_pki_secret_backend_intermediate_cert_request.int_csr.csr
  common_name = "Nomad Intermediate CA ${var.nomad_region}"
  ttl         = "43800h" # 5 years
}


resource "vault_pki_secret_backend_intermediate_set_signed" "int_cert" {
  backend     = vault_mount.pki_int.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.signed_int.certificate
}


resource "vault_pki_secret_backend_config_urls" "int_urls" {
  backend                 = vault_mount.pki_int.path
  issuing_certificates    = ["${var.vault_addr}/v1/pki-int-${var.nomad_region}/ca"]
  crl_distribution_points = ["${var.vault_addr}/v1/pki-int-${var.nomad_region}/crl"]
  ocsp_servers            = ["${var.vault_addr}/v1/pki-int-${var.nomad_region}/ocsp"]
}


resource "vault_pki_secret_backend_crl_config" "crl" {
  backend = vault_mount.pki_int.path
  expiry  = "72h"
}


# Nomad server cert role
resource "vault_pki_secret_backend_role" "nomad_server" {
  backend          = vault_mount.pki_int.path
  name             = "${var.nomad_region}nomad-server"
  allowed_domains  = ["${var.route53_nomad_hosted_zone_name}"]
  allow_subdomains = true
  max_ttl          = "8760h" # 1 year
  allow_any_name   = false
}

# # Nomad client cert role
# resource "vault_pki_secret_backend_role" "nomad_client" {
#   backend          = vault_mount.pki_int.path
#   name             = "nomad-client"
#   allowed_domains  = ["nomad.${var.nomad_region}.example.com"]
#   allow_subdomains = true
#   max_ttl          = "8760h" # 1 year
#   allow_any_name   = false
# }

resource "vault_policy" "tls_policy" {
  name   = "tls-policy"
  policy = <<EOT
path "pki-int-${var.nomad_region}/issue/nomad-server" {
  capabilities = ["update"]
}
EOT
}

resource "vault_approle_auth_backend_role" "nomad_server" {
  backend        = "approle"
  role_name      = "${var.nomad_region}-nomad-server"
  token_policies = [vault_policy.tls_policy.name]
  token_ttl      = 3600
  token_max_ttl  = 14400
  secret_id_ttl  = 86400
}


#------------------------------------------------------------------------------
# Nomad License 
#------------------------------------------------------------------------------
# Recommended licenses are stored in vault manually instead of adding in a tfvars file. 

data "vault_kv_secret_v2" "license" {
  mount = var.vault_license_mount
  name  = var.vault_license_secret
}

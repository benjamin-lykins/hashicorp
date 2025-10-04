# Enable a PKI secrets engine for the Root CA
resource "vault_mount" "pki_root" {
  path                      = "pki-root"
  type                      = "pki"
  description               = "Root PKI"
  default_lease_ttl_seconds = 315360000
  max_lease_ttl_seconds     = 315360000
}

# Generate the Root CA (self-signed)
resource "vault_pki_secret_backend_root_cert" "root" {
  backend              = vault_mount.pki_root.path
  type                 = "internal"
  common_name          = "Nomad Root CA"
  ttl                  = "87600h" # 10 years
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
}

# Configure issuing/CRL URLs
resource "vault_pki_secret_backend_config_urls" "root_urls" {
  backend                 = vault_mount.pki_root.path
  issuing_certificates    = ["https://lykins-vault-cluster-public-vault-c88a9e9f.e7ddc59e.z1.hashicorp.cloud:8200/v1/pki-root/ca"]
  crl_distribution_points = ["https://lykins-vault-cluster-public-vault-c88a9e9f.e7ddc59e.z1.hashicorp.cloud:8200/v1/pki-root/crl"]
  ocsp_servers            = ["https://lykins-vault-cluster-public-vault-c88a9e9f.e7ddc59e.z1.hashicorp.cloud:8200/v1/pki-root/ocsp"]
}

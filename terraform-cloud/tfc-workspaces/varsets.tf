resource "tfe_variable_set" "vault" {
  name         = "vault-dynamic"
  organization = var.organization
  description  = "Used for Dynamic Credentials with Vault and TFC"
  global       = false
}

resource "tfe_variable" "enable_vault_provider_auth" {
  variable_set_id = tfe_variable_set.vault.id

  key      = "TFC_VAULT_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for Vault."
}

resource "tfe_variable" "tfc_vault_addr" {
  variable_set_id = tfe_variable_set.vault.id

  key       = "TFC_VAULT_ADDR"
  value     = var.vault_addr
  category  = "env"
  sensitive = true

  description = "The address of the Vault instance runs will access."
}

resource "tfe_variable" "tfc_vault_role" {
  variable_set_id = tfe_variable_set.vault.id

  key      = "TFC_VAULT_RUN_ROLE"
  value    = "tfc-role"
  category = "env"

  description = "The Vault role runs will use to authenticate."
}

resource "tfe_variable" "tfc_vault_namespace" {
  variable_set_id = tfe_variable_set.vault.id

  key      = "TFC_VAULT_NAMESPACE"
  value    = "admin"
  category = "env"

  description = "The Vault namespace to use, if not using the default"
}


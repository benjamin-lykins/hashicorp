resource "vault_mount" "licenses" {
  path        = "hashicorp/licenses/"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secret engine mount"
}


resource "vault_kv_secret_v2" "licenses" {
  mount               = vault_mount.licenses.path
  name                = "licenses"
  delete_all_versions = true
  data_json = jsonencode(
    {
      nomad_enterprise     = var.nomad_enterprise_license
      vault_enterprise     = var.vault_enterprise_license
      consul_enterprise    = var.consul_enterprise_license
      terraform_enterprise = var.terraform_enterprise_license

    }
  )
}



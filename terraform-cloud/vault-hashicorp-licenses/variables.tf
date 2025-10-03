variable "nomad_enterprise_license" {
  type        = string
  description = "The Nomad Enterprise license to store in Vault"
  sensitive   = true
}

variable "vault_enterprise_license" {
  type        = string
  description = "The Vault Enterprise license to store in Vault"
  sensitive   = true

}

variable "consul_enterprise_license" {
  type        = string
  description = "The Consul Enterprise license to store in Vault"
  sensitive   = true

}

variable "terraform_enterprise_license" {
  type        = string
  description = "The Terraform Enterprise license to store in Vault"
  sensitive   = true

}

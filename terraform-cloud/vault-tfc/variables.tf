# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "vault_url" {
  type        = string
  description = "The URL of the Vault instance you'd like to use with Terraform Cloud"
}

variable "jwt_backend_path" {
  type        = string
  default     = "jwt"
  description = "The path at which you'd like to mount the jwt auth backend in Vault"
}

variable "tfc_vault_audience" {
  type        = string
  default     = "vault.workload.identity"
  description = "The audience value to use in run identity tokens"
}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Vault"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
}


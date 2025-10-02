terraform {
  required_version = "~> 1.0"

  cloud {
    organization = "lykins"

    workspaces {
      name = "vault-tfc-integration"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "> 0.0.0"
    }
  }
}

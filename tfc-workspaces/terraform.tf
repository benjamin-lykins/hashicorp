terraform {
  required_version = "~> 1.0"

  cloud {
    organization = "lykins"

    workspaces {
      name = "control-ws"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "> 0.0.0"
    }
  }
}

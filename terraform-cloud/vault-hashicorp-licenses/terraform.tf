terraform {
  required_version = "~> 1.0"
  cloud {
    organization = "lykins"
    workspaces {
      name = "vault-hashicorp-licenses"
    }
  }
}

provider "vault" {
}

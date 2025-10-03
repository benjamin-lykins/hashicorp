# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_version = ">= 1.9"
  cloud {
    organization = "lykins"
    workspaces {
      tags = {
        repository = "nomad-enterprise-servers-bvd"
      }
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "terraform.workspace" = "${terraform.workspace}"
    }
  }
}

provider "vault" {
}

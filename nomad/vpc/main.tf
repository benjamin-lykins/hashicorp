terraform {
  # Optional backend configuration with Terraform Cloud. 
  cloud {
    organization = "lykins"
    workspaces {
      tags = ["nomad", "vpc"]
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.provider_aws_region
}

variable "provider_aws_region" {
  description = "AWS region to authenticate provider."
  type        = string
  default     = "us-east-2"
}

variable "prefix" {
  description = "Prefix for resource names."
  type        = string
  default     = "dev"
}

variable "region_configs" {
  type = map(object({
    cidr_block           = string
    private_subnet_cidrs = list(string)
    public_subnet_cidrs  = list(string)
  }))
  default = {
    us-east-2 = {
      cidr_block           = "10.1.0.0/16"
      private_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
      public_subnet_cidrs  = ["10.1.3.0/24", "10.1.4.0/24"]
    }
    us-west-2 = {
      cidr_block           = "10.2.0.0/16"
      private_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
      public_subnet_cidrs  = ["10.2.3.0/24", "10.2.4.0/24"]
    }
  }
}

variable "vpc_peering" {
  description = "Map of VPC Peering Configurations"
  type = map(object({
    peer_requestor_region = string
    peer_accepter_region  = string
  }))
  default = {
    "useast_to_uswest" = {
      peer_requestor_region = "us-east-2"
      peer_accepter_region  = "us-west-2"
    }
  }
}


module "nomad_vpc" {
  source   = "app.terraform.io/lykins/terraform-aws-nomad-vpc/aws"
  version  = "0.0.1"
  for_each = var.region_configs

  aws_region           = each.key
  vpc_cidr             = each.value.cidr_block
  private_subnet_cidrs = each.value.private_subnet_cidrs
  public_subnet_cidrs  = each.value.public_subnet_cidrs
}

output "vpc_ids" {
  description = "The IDs of the VPCs"
  value       = { for k, v in module.nomad_vpc : k => v.vpc_id }
}

output "public_subnet_ids" {
  description = "Map of region to list of public subnet IDs"
  value       = { for k, v in module.nomad_vpc : k => v.public_subnet_ids }
}

output "private_subnet_ids" {
  description = "Map of region to list of private subnet IDs"
  value       = { for k, v in module.nomad_vpc : k => v.private_subnet_ids }
}

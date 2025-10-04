# --- Common --- #
friendly_name_prefix = "bvd"
common_tags = {
}
aws_region = "us-east-2"

# --- Prereqs --- #
additional_package_names = ["htop"]

# --- Nomad Configuration Settings --- # 
nomad_upstream_servers = ["127.0.0.1"]
nomad_region           = "useast"
nomad_datacenter       = "dc1"
nomad_version          = "1.10.5+ent"
nomad_architecture     = "amd64"


# --- Networking --- #
vpc_id                   = "vpc-0e9acb5db8f3e3855"
instance_subnets         = ["subnet-04d78b86eb6584607", "subnet-0d1f0a26b6b25ab5a", "subnet-090dc2b46d57022d3"]
associate_public_ip      = false
cidr_allow_ingress_nomad = ["0.0.0.0/0"]
permit_all_egress        = true
lb_is_internal           = false
lb_subnet_ids            = ["subnet-0252903206d749d94", "subnet-0701306e5b9347644", "subnet-008a82139d98216a0"]

# --- Compute --- #

nomad_nodes      = 1
ebs_is_encrypted = true
key_name         = "mac"
ec2_allow_ssm    = true

# --- DNS --- #
create_route53_nomad_dns_record      = true
route53_nomad_hosted_zone_name       = "benjamin-lykins.sbx.hashidemos.io"
route53_nomad_hosted_zone_is_private = false
nomad_fqdn                           = "lab-nomad.benjamin-lykins.sbx.hashidemos.io"


# --- Vault --- #
vault_addr           = "https://lykins-vault-cluster-public-vault-c88a9e9f.e7ddc59e.z1.hashicorp.cloud:8200"
vault_license_mount  = "licenses"
vault_license_secret = "hashicorp"

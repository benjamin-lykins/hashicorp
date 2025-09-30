# --- Common --- #
friendly_name_prefix = "bvd"
common_tags = {
}
aws_region = "us-east-2"

# --- Prereqs --- #
nomad_license_secret_arn               = "arn:aws:secretsmanager:us-east-2:050752626041:secret:lab-nomad-license-UkeKX2"
nomad_gossip_encryption_key_secret_arn = "arn:aws:secretsmanager:us-east-2:050752626041:secret:lab-nomad-gossip-frMG15"
nomad_tls_cert_secret_arn              = "arn:aws:secretsmanager:us-east-2:050752626041:secret:lab-nomad-tls-cert-base64-mnq3k4"
nomad_tls_privkey_secret_arn           = "arn:aws:secretsmanager:us-east-2:050752626041:secret:lab-nomad-tls-privkey-base64-6kaYw3"
nomad_tls_ca_bundle_secret_arn         = "arn:aws:secretsmanager:us-east-2:050752626041:secret:lab-nomad-tls-ca-bundle-base64-6kaYw3"
additional_package_names               = ["htop"]

# --- Nomad Configuration Settings --- # 
nomad_acl_enabled        = false
nomad_tls_enabled        = true
nomad_client             = false
nomad_server             = true
nomad_ui_enabled         = true
nomad_upstream_servers   = ["127.0.0.1"]
nomad_region             = "useast"
nomad_datacenter         = "dc1"
autopilot_health_enabled = true
nomad_version            = "1.10.5+ent"
cni_version              = "1.6.0"
nomad_architecture       = "amd64"


# --- Networking --- #
vpc_id                   = "vpc-0e9acb5db8f3e3855"
instance_subnets         = ["subnet-04d78b86eb6584607", "subnet-0d1f0a26b6b25ab5a", "subnet-090dc2b46d57022d3"]
associate_public_ip      = false
cidr_allow_ingress_nomad = ["0.0.0.0/0"]
permit_all_egress        = true
lb_is_internal           = false
lb_subnet_ids            = ["subnet-0252903206d749d94", "subnet-0701306e5b9347644", "subnet-008a82139d98216a0"]

# --- Compute --- #
ec2_os_distro    = "ubuntu"
instance_type    = "m5.large"
nomad_nodes      = 3
ebs_is_encrypted = true
key_name         = "mac"
ec2_allow_ssm    = true

# --- DNS --- #
create_route53_nomad_dns_record      = true
route53_nomad_hosted_zone_name       = "benjamin-lykins.sbx.hashidemos.io"
route53_nomad_hosted_zone_is_private = false
nomad_fqdn                           = "lab-nomad.benjamin-lykins.sbx.hashidemos.io"

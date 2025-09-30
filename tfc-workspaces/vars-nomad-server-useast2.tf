resource "tfe_variable" "this" {
  for_each = {
    # --- Common --- #
    friendly_name_prefix = "<prod-server>"
    common_tags = {
      Environment = "<prod>"
      Project     = "<nomad>"
    }
    region = "<us-east-1>"

    # --- Prereqs --- #
    # nomad_license_secret_arn                = "<arn:aws:secretsmanager:us-west-2:123456789012:secret:nomad-license>"
    # nomad_gossip_encryption_key_secret_arn  = "<arn:aws:secretsmanager:us-west-2:123456789012:secret:gossip-encryption-key>"
    # nomad_tls_cert_secret_arn               = "<arn:aws:secretsmanager:us-west-2:123456789012:secret:tls-cert>"
    # nomad_tls_privkey_secret_arn            = "<arn:aws:secretsmanager:us-west-2:123456789012:secret:tls-privkey>"
    # nomad_tls_ca_bundle_secret_arn          = "<arn:aws:secretsmanager:us-west-2:123456789012:secret:tls-ca-bundle>"
    # additional_package_names                = ["<htop>"]

    # --- Nomad Configuration Settings --- # 
    nomad_acl_enabled        = true
    nomad_client             = false
    nomad_server             = true
    nomad_ui_enabled         = true
    nomad_upstream_servers   = ["127.0.0.1"]
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
    ec2_os_distro    = "<ubuntu>"
    instance_type    = "<m5.large>"
    nomad_nodes      = 3
    ebs_is_encrypted = true
    key_name         = "<my-ssh-key>"
    ec2_allow_ssm    = true

    # --- DNS --- #
    create_route53_nomad_dns_record      = false
    route53_nomad_hosted_zone_name       = "<aws.company.com>"
    route53_nomad_hosted_zone_is_private = false
    nomad_fqdn                           = "<nomad.aws.company.com>"
  }

  key          = each.key
  value        = substr(replace(jsonencode(each.value), "/(\".*?\"):/", "$1 = "), 0, 1) == "[" || substr(replace(jsonencode(each.value), "/(\".*?\"):/", "$1 = "), 0, 1) == "{" ? replace(jsonencode(each.value), "/(\".*?\"):/", "$1 = ") : replace(jsonencode(each.value), "\"", "") # https://github.com/hashicorp/terraform-provider-tfe/issues/188
  category     = "terraform"
  workspace_id = module.nomad["nomad-servers-useast2"].workspace_id
  hcl          = substr(replace(jsonencode(each.value), "/(\".*?\"):/", "$1 = "), 0, 1) == "[" || substr(replace(jsonencode(each.value), "/(\".*?\"):/", "$1 = "), 0, 1) == "{" ? true : false # https://github.com/hashicorp/terraform-provider-tfe/issues/188

  depends_on = [module.nomad]
}

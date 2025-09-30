resource "tfe_project" "this" {
  name         = "nomad"
  organization = var.organization
}


module "vault" {
  for_each = var.workspaces.vault

  source  = "alexbasista/workspacer/tfe"
  version = "0.13.0"

  workspace_name = each.key
  project_name   = each.value.project_name
  organization   = var.organization

  agent_pool_id      = each.value.agent_pool_id
  auto_apply         = each.value.auto_apply
  envvars            = each.value.envvars
  queue_all_runs     = each.value.queue_all_runs
  vcs_repo           = each.value.vcs_repo
  working_directory  = each.value.working_directory
  workspace_desc     = each.value.workspace_desc
  workspace_map_tags = each.value.workspace_map_tags
  tfvars             = each.value.tfvars

  depends_on = [tfe_project.this]
}


module "nomad" {
  for_each = var.workspaces.nomad

  source  = "alexbasista/workspacer/tfe"
  version = "0.13.0"

  workspace_name = each.key
  project_name   = each.value.project_name
  organization   = var.organization

  agent_pool_id      = each.value.agent_pool_id
  auto_apply         = each.value.auto_apply
  envvars            = each.value.envvars
  queue_all_runs     = each.value.queue_all_runs
  vcs_repo           = each.value.vcs_repo
  working_directory  = each.value.working_directory
  workspace_desc     = each.value.workspace_desc
  workspace_map_tags = each.value.workspace_map_tags
  tfvars             = each.value.tfvars

  depends_on = [tfe_project.this]
}

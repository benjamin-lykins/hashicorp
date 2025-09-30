variable "workspaces" {
  description = "A map of workspaces to create."
  type = map(object({
    agent_pool_id  = optional(string, null)
    auto_apply     = optional(bool, true)
    envvars        = optional(map(string), {})
    project_name   = optional(string, null)
    queue_all_runs = optional(bool, true)
    vcs_repo = object({
      identifier                 = string
      branch                     = optional(string, null)
      oauth_token_id             = optional(string, null)
      github_app_installation_id = optional(string, null)
      ingress_submodules         = optional(bool, false)
      tags_regex                 = optional(string, null)
    })
    working_directory = optional(string, null)
    workspace_desc    = optional(string, "Created by Workspacer Module")
    workspace_map_tags = optional(map(string), {
      module = "workspacer"
    })
  }))
  default = {
  }
}




module "nomad" {
  for_each = var.workspaces

  source  = "alexbasista/workspacer/tfe"
  version = "0.13.0"

  workspace_name = each.key
  project_name   = each.value.project_name
  organization   = var.organization

  agent_pool_id      = each.key.agent_pool_id
  auto_apply         = each.key.auto_apply
  envvars            = each.value.envvars
  queue_all_runs     = each.value.queue_all_runs
  vcs_repo           = each.value.vcs_repo
  working_directory  = each.value.working_directory
  workspace_desc     = each.value.workspace_desc
  workspace_map_tags = each.value.workspace_map_tags
}

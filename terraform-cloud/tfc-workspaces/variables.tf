variable "organization" {
  description = "The name of the organization in which to create the workspace."
  type        = string
  default     = "lykins"

}

variable "projects" {
  description = "A list of projects to create in the organization."
  type        = list(string)
}

variable "vault_addr" {
  description = "The URL of the Vault instance to use for dynamic credentials."
  type        = string
  default     = ""

}

variable "workspaces" {
  description = "A map of workspaces to create."
  type = map(map(object({
    agent_pool_id  = optional(string, null)
    auto_apply     = optional(bool, true)
    envvars        = optional(map(string), {})
    project_name   = optional(string, "Default Project")
    queue_all_runs = optional(bool, true)
    tfvars         = optional(map(string), {})
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
    workspace_tags = optional(list(string), [])
  })))
  default = {
  }
}

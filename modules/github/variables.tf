variable "actions_environments" {
  type = map(object({
    can_admins_bypass   = optional(bool)
    prevent_self_review = optional(bool)
    wait_timer          = optional(number)

    deployment_branch_policy = optional(object({
      protected_branches     = bool
      custom_branch_policies = bool
    }))

    reviewers = optional(object({
      teams = optional(list(string))
      users = optional(list(string))
    }))
  }))
  default     = {}
  description = "Environments to configure for the repository."
}

variable "actions_variables" {
  default     = {}
  description = "Repository environment variables to set for GitHub Actions."
}

variable "actions_secrets" {
  default     = {}
  description = "Repository environment secrets to set for GitHub Actions."
}

variable "deploy_key" {
  type = map(object({
    read_only = bool
  }))
  default     = {}
  description = "Map of GitHub repositories to add a deploy key to."
}

variable "full_name" {
  description = "Full name of the repository (in `org/name` format)."
  default     = null
  type        = string
}

variable "name" {
  description = "The name of the repository."
  default     = null
  type        = string
}

variable "project" {
  type        = string
  description = "The project ID where resources are created."
}

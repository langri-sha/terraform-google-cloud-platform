variable "actions_variables" {
  default     = {}
  description = "Repository environment variables to set for GitHub Actions."
}

variable "actions_secrets" {
  default     = {}
  description = "Repository environment secrets to set for GitHub Actions."
}

variable "attribute_condition" {
  type        = string
  default     = null
  description = "CEL expression that restricts which tokens can authenticate against the Workload Identity Pool provider (e.g., `assertion.repository_owner == 'my-org'`). When null, all tokens from the GitHub OIDC issuer are accepted and access is gated solely by the service account IAM bindings."
}

variable "attribute_mapping" {
  type = map(string)
  default = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.aud"        = "assertion.aud"
    "attribute.repository" = "assertion.repository"
  }
  description = "Claim mapping from the GitHub OIDC token to Google Workload Identity attributes. Override to surface additional claims (e.g., `attribute.environment`, `attribute.ref`, `attribute.job_workflow_ref`) for use in IAM conditions."
}

variable "deploy_key" {
  type = map(object({
    read_only = bool
  }))
  default     = {}
  description = "Map of GitHub repositories to add a deploy key to."
}

variable "environments" {
  type = map(object({
    actions_secrets   = optional(map(string), {})
    actions_variables = optional(map(string), {})
  }))
  default     = {}
  description = "Map of Github Actions environments, with their variables and secrets."
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

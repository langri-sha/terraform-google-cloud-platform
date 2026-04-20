variable "project" {
  type        = string
  description = "The project ID where secret resources are centralized."
}

variable "secrets" {
  type        = list(string)
  description = "Descriptive names of secrets to create."
}

variable "secret_accessors" {
  type        = list(string)
  default     = []
  description = "Service accounts given permission to read secrets."
}

variable "topic" {
  type        = string
  description = "Some descriptive text that will be added to the labels for this set of secrets in the project, e.g. 'cloudbuild'."
}

variable "read_secret_version" {
  type        = map(string)
  default     = {}
  description = "Map of secrets and the version for which secret data is to be retrieved. For secret data to be read and used in TF configurations."
}

variable "write_secret_data" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Map of secrets and their plaintext data to write as new secret versions. Keys must match entries in `secrets`."
}

variable "write_secret_data_base64" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Map of secrets and their base64-encoded data to write as new secret versions. Use for binary data like certificates or keys. Keys must match entries in `secrets`."
}

variable "deletion_policy" {
  type        = string
  default     = "DISABLE"
  description = "What Terraform does to the prior secret version when it is replaced (e.g. on rotation) or destroyed. DISABLE (default) keeps the version but marks it disabled so stale consumers fail loudly and rollback is possible. DELETE permanently destroys it. ABANDON drops it from Terraform state and leaves it enabled."
  validation {
    condition     = contains(["DELETE", "DISABLE", "ABANDON"], var.deletion_policy)
    error_message = "deletion_policy must be one of: DELETE, DISABLE, ABANDON."
  }
}

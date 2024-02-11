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

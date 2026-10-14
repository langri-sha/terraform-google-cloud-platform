variable "dns_admins" {
  description = "List of service account emails that will be assigned as DNS admins in the related project."
  type        = list(string)
}

variable "domain" {
  description = "Domain for which resources are created."
  type        = string
}

variable "project_id" {
  description = "Project where resources belong to."
  type        = string
}

variable "mx_records" {
  description = "MX record destinations and their priorities."
  type        = map(number)
}

variable "site_verifications" {
  description = "Comma-separated list of DNS-based domain ownership verifications."
  type        = list(string)
}

variable "subdomain_verifications" {
  description = "DNS-based domain ownership verifications that are asked for on a subdomain, keyed by that subdomain. Values carry their own surrounding quotes, as the apex verifications do."
  type        = map(string)
  default     = {}
}

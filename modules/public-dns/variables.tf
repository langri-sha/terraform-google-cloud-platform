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

variable "zone_name" {
  description = "Name of the managed zone. Names are unique within a project, so a second zone in the same project needs its own."
  type        = string
  default     = "public"
}

variable "dkim_keys" {
  description = "DKIM public keys, keyed by selector and written to `<selector>._domainkey`. Values are the bare record text, without surrounding quotes; the module splits them into the 255-character strings a TXT record is made of."
  type        = map(string)
  default     = {}
}

variable "spf" {
  description = "SPF policy for the apex, as the bare record text without surrounding quotes. A zone holds one TXT record set per name, so the module adds it to the one the site verifications are in."
  type        = string
  default     = null
}

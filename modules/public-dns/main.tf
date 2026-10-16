resource "google_dns_managed_zone" "public" {
  dns_name = "${var.domain}."
  name     = var.zone_name
  project  = var.project_id
}

resource "google_dns_record_set" "mx" {
  name    = google_dns_managed_zone.public.dns_name
  project = var.project_id

  managed_zone = google_dns_managed_zone.public.name
  rrdatas      = [for destination, priority in var.mx_records : "${priority} ${destination}"]
  ttl          = 3600
  type         = "MX"
}

locals {
  apex_txt = concat(var.site_verifications, var.spf == null ? [] : ["\"${var.spf}\""])
}

resource "google_dns_record_set" "site_verifications" {
  count = length(local.apex_txt) > 0 ? 1 : 0

  name    = google_dns_managed_zone.public.dns_name
  project = var.project_id

  managed_zone = google_dns_managed_zone.public.name
  rrdatas      = local.apex_txt
  ttl          = 300
  type         = "TXT"
}

resource "google_dns_record_set" "subdomain_verifications" {
  for_each = var.subdomain_verifications

  name    = "${each.key}.${google_dns_managed_zone.public.dns_name}"
  project = var.project_id

  managed_zone = google_dns_managed_zone.public.name
  rrdatas      = [each.value]
  ttl          = 3600
  type         = "TXT"
}

resource "google_dns_record_set" "dkim" {
  for_each = var.dkim_keys

  name    = "${each.key}._domainkey.${google_dns_managed_zone.public.dns_name}"
  project = var.project_id

  managed_zone = google_dns_managed_zone.public.name
  rrdatas = [join(" ", [
    for offset in range(0, length(each.value), 255) :
    "\"${substr(each.value, offset, 255)}\""
  ])]
  ttl  = 3600
  type = "TXT"
}

resource "google_project_iam_member" "service_account_dns_admin" {
  for_each = toset(var.dns_admins)

  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${each.value}"
}

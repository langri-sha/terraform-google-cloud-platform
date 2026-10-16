mock_provider "google" {}

variables {
  dns_admins = []
  domain     = "example.com"
  project_id = "org-0000"
  mx_records = {
    "aspmx.l.google.com." = 1
  }
  site_verifications = []
}

run "the_zone_is_called_public_by_default" {
  command = plan

  assert {
    condition     = google_dns_managed_zone.public.name == "public"
    error_message = "An existing zone must keep its name unless a consumer chooses another."
  }
}

run "the_zone_takes_the_name_it_is_given" {
  command = plan

  variables {
    zone_name = "example-com"
  }

  assert {
    condition     = google_dns_managed_zone.public.name == "example-com"
    error_message = "A second zone in the project needs a name of its own."
  }

  assert {
    condition     = google_dns_record_set.mx.managed_zone == "example-com"
    error_message = "Record sets must follow the zone's name."
  }
}

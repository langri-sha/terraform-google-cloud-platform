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

run "no_dkim_keys_declare_no_records" {
  command = plan

  assert {
    condition     = length(google_dns_record_set.dkim) == 0
    error_message = "An empty input must declare no DKIM records at all."
  }
}

run "a_dkim_key_lands_on_its_selector_under_domainkey" {
  command = plan

  variables {
    dkim_keys = {
      google = "v=DKIM1; k=rsa; p=abc"
    }
  }

  assert {
    condition     = google_dns_record_set.dkim["google"].name == "google._domainkey.example.com."
    error_message = "The record must sit at <selector>._domainkey in the zone."
  }

  assert {
    condition     = one(google_dns_record_set.dkim["google"].rrdatas) == "\"v=DKIM1; k=rsa; p=abc\""
    error_message = "A short key must be one quoted string."
  }
}

run "a_dkim_key_over_255_characters_splits_into_quoted_strings" {
  command = plan

  variables {
    dkim_keys = {
      google = "${join("", [for i in range(0, 255) : "a"])}${join("", [for i in range(0, 10) : "b"])}"
    }
  }

  assert {
    condition     = one(google_dns_record_set.dkim["google"].rrdatas) == "\"${join("", [for i in range(0, 255) : "a"])}\" \"bbbbbbbbbb\""
    error_message = "Each string of a TXT record is limited to 255 characters, so the key must be split there."
  }
}

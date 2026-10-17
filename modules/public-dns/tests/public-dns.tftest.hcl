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

run "no_spf_leaves_the_apex_text_records_as_they_were" {
  command = plan

  variables {
    site_verifications = ["\"google-site-verification=abc\""]
  }

  assert {
    condition     = toset(google_dns_record_set.site_verifications[0].rrdatas) == toset(["\"google-site-verification=abc\""])
    error_message = "A consumer that sets no SPF must see no change to its apex records."
  }
}

run "no_verifications_and_no_spf_declare_no_apex_text_records" {
  command = plan

  assert {
    condition     = length(google_dns_record_set.site_verifications) == 0
    error_message = "An empty apex must declare no TXT record set."
  }
}

run "an_spf_policy_joins_the_site_verifications_in_one_record_set" {
  command = plan

  variables {
    site_verifications = ["\"google-site-verification=abc\""]
    spf                = "v=spf1 include:_spf.google.com ~all"
  }

  assert {
    condition = toset(google_dns_record_set.site_verifications[0].rrdatas) == toset([
      "\"google-site-verification=abc\"",
      "\"v=spf1 include:_spf.google.com ~all\"",
    ])
    error_message = "Cloud DNS holds one TXT record set per name, so SPF must share the apex set with the verifications."
  }
}

run "an_spf_policy_alone_still_declares_the_apex_record_set" {
  command = plan

  variables {
    spf = "v=spf1 include:_spf.google.com ~all"
  }

  assert {
    condition     = toset(google_dns_record_set.site_verifications[0].rrdatas) == toset(["\"v=spf1 include:_spf.google.com ~all\""])
    error_message = "SPF without verifications must not need a verification to exist."
  }
}

run "no_dmarc_policy_declares_no_record" {
  command = plan

  assert {
    condition     = length(google_dns_record_set.dmarc) == 0
    error_message = "An unset policy must declare no record set."
  }
}

run "a_dmarc_policy_lands_quoted_on_underscore_dmarc" {
  command = plan

  variables {
    dmarc = "v=DMARC1; p=none; rua=mailto:dmarc-reports@example.com"
  }

  assert {
    condition     = google_dns_record_set.dmarc[0].name == "_dmarc.example.com."
    error_message = "The record must sit at _dmarc in the zone."
  }

  assert {
    condition     = one(google_dns_record_set.dmarc[0].rrdatas) == "\"v=DMARC1; p=none; rua=mailto:dmarc-reports@example.com\""
    error_message = "The policy must be one quoted string."
  }
}

run "a_quoted_dmarc_policy_is_rejected_because_the_module_adds_the_quotes" {
  command = plan

  variables {
    dmarc = "\"v=DMARC1; p=none\""
  }

  expect_failures = [var.dmarc]
}

run "a_value_that_is_not_a_dmarc_policy_is_rejected" {
  command = plan

  variables {
    dmarc = "v=spf1 -all"
  }

  expect_failures = [var.dmarc]
}

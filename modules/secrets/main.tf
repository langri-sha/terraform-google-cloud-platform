resource "google_secret_manager_secret" "secret" {
  for_each = toset(var.secrets)

  project   = var.project
  secret_id = each.value

  labels = {
    topic = var.topic
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_iam_member" "secret_accessors" {
  for_each = {
    for pair in setproduct(var.secret_accessors, var.secrets) : "${pair[0]}_${pair[1]}" => {
      member = pair[0]
      secret = pair[1]
    }
  }

  member    = each.value.member
  project   = google_secret_manager_secret.secret[each.value.secret].project
  role      = "roles/secretmanager.secretAccessor"
  secret_id = google_secret_manager_secret.secret[each.value.secret].id
}

data "google_secret_manager_secret_version" "secret_data" {
  for_each = var.read_secret_version

  project = google_secret_manager_secret.secret[each.key].project
  secret  = google_secret_manager_secret.secret[each.key].id
  version = each.value
}

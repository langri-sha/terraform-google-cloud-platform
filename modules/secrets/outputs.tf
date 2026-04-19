output "secret_data" {
  value = zipmap(
    keys(data.google_secret_manager_secret_version.secret_data),
    values(data.google_secret_manager_secret_version.secret_data)[*].secret_data
  )
  description = "Secret plaintexts."
}

output "secret_names" {
  value = zipmap(
    values(google_secret_manager_secret.secret)[*].secret_id,
    values(google_secret_manager_secret.secret)[*].id
  )
  description = "Secret names mapped to their full resource IDs."
}

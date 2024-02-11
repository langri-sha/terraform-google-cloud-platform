output "service_account" {
  value       = google_service_account.github_actions
  description = "GitHub Actions service account."
}

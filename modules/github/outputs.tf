output "deploy_key" {
  value       = tls_private_key.deploy_key
  description = "GitHub repository deploy key."
}

output "service_account" {
  value       = google_service_account.github_actions
  description = "GitHub Actions service account."
}

output "workload_identity_provider" {
  value       = module.github_actions_workload_identity_federation.provider_name
  description = "GitHub Actions workload identity provider."
}

# terraform-google-cloud-platform

A collection of Terraform modules for bootstrapping and managing resources on
Google Cloud Platform.

## Modules

| Module                                                    | Description                                                                   |
| --------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [`access-token-resolver`](modules/access-token-resolver/) | Resolves an access token from a service account.                              |
| [`cloudbuild`](modules/cloudbuild/)                       | Provisions a Cloud Build project with shared build resources.                 |
| [`github`](modules/github/)                               | Configures a GitHub repository for keyless authentication and GitHub Actions. |
| [`org`](modules/org/)                                     | Configures organization-level IAM and policies.                               |
| [`public-dns`](modules/public-dns/)                       | Manages a public DNS zone.                                                    |
| [`secrets`](modules/secrets/)                             | Manages a set of secrets in Secret Manager.                                   |
| [`terraform-admin`](modules/terraform-admin/)             | Bootstraps a project used for Terraform state and administration.             |
| [`workspace`](modules/workspace/)                         | Configures a Google Workspace project.                                        |

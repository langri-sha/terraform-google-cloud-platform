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

## Usage

Source a module from this repository and pin it to a release tag:

```hcl
module "secrets" {
  source = "github.com/langri-sha/terraform-google-cloud-platform//modules/secrets?ref=vX.Y.Z"

  project = var.project_id
  topic   = "cloudbuild"
  secrets = ["api-token"]
}
```

Each release tag, `vX.Y.Z`, covers every module; the [releases] list them with
their notes. A module's inputs are in its `variables.tf`, and the `github` and
`secrets` modules have a README with a fuller example.

## Contributing

Run `terraform fmt -recursive` before opening a pull request; CI checks the
formatting and validates every module. See [CONTRIBUTING.md] in
`langri-sha/github`.

[contributing.md]:
  https://github.com/langri-sha/github/blob/main/CONTRIBUTING.md
[releases]:
  https://github.com/langri-sha/terraform-google-cloud-platform/releases

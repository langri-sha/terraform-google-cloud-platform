# GitHub

Configures a GitHub repository with resources that are controlled by automation,
mostly for [enabling keyless authentication], configuring the [GitHub Actions]
environment, and setting sensible repository defaults.

## Usage

```hcl
module "github" {
  source = "git@github.com:langri-sha/terraform-google-cloud-platform\.git//modules/github"

  full_name = "langri-sha/langri-sha.com"
  project   = var.project

  actions_environments = {
    preview    = null
    production = {
      can_admins_bypass = false
    }
  }

  actions_variables = {
    some_property = "serializiable"
  }

  actions_secrets = {
    SUPER = "secret"
  }

  deploy_key = {
    "my-org/other-repo" = {
      read_only: true
    }
  }
}
```

[enabling keyless authentication]: https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions
[github actions]: https://github.com/features/actions

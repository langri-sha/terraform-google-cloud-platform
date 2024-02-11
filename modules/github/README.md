# GitHub

Configures a GitHub repository with resources that are controlled by automation,
mostly for [enabling keyless authentication] and configuring the [GitHub Actions]
environment.

## Usage

```hcl
module "github" {
  source = "git@github.com:langri-sha/terraform-google-cloud-platform\.git//modules/github"
}
```

[enabling keyless authentication]: https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions
[github actions]: https://github.com/features/actions

# Agents orientation — `langri-sha/terraform-google-cloud-platform`

Reusable Terraform modules for Google Cloud Platform, consumed from other
repositories by Git source and release tag. Nothing here is planned or applied;
consumers do that in their own repositories. Projen manages the tooling around
the modules.

```text
modules/<name>/   # one module: main.tf, variables.tf, outputs.tf, versions.tf
examples/<name>/  # optional root that CI validates instead of the module
```

## Who owns which file

Projen writes `package.json` and every file listed in `.projen/files.json`; they
are read-only. Change them in `.projenrc.ts`, then run `pnpm exec projen`.
Everything else — `modules/`, `examples/`, `README.md`, `.github/workflows/`,
this file — is edited by hand. Repository settings, branch protection and the
Actions secrets are managed by `langri-sha/github-repos`.

## Common tasks

```sh
pnpm install
pnpm exec projen          # re-synthesize from .projenrc.ts
terraform fmt -recursive  # format every module and example
pnpm prettier --check .
pnpm tsc --build .
```

## Modules and CI

`terraform.yml` checks `terraform fmt -check -recursive`, then runs
`terraform init -backend=false` and `terraform validate` in every directory
under `modules/`, so a new module needs no workflow change. A module that
declares provider configuration aliases, like `workspace`, can't be validated as
a root: give it an `examples/<name>/` that passes the providers, and CI
validates that directory in its place.

The Terraform version CI uses is `TERRAFORM_VERSION` in `terraform.yml`'s `env`.
A Renovate regex manager in `.projenrc.ts` matches that exact
`TERRAFORM_VERSION: <version>` line, so keep its shape. Modules don't commit
`.terraform.lock.hcl`.

CI (`workspace.yml` → `langri-sha/github` `check.yml`) also runs Prettier and
`tsc --build`, and fails when synthesized files drift from `.projenrc.ts`. On
Renovate pull requests it re-synthesizes and commits the result.

## Release

One repo-wide semver tag, `vX.Y.Z`, on `main` covers every module; consumers pin
`github.com/langri-sha/terraform-google-cloud-platform//modules/<module>?ref=vX.Y.Z`.
Each tag gets a GitHub Release with generated notes:
`gh release create vX.Y.Z --generate-notes`. Nothing tags on merge.

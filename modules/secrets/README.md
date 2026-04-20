# Secrets

A module that manages a set of secrets in a project.

## Usage

You can use this module to quickly create a set of secrets, which will be
assigned a descriptive label in the project by the given topic.

You can optionally provide a list of members which will be given the secret
accessor role.

For secrets that are to be used later in the Terraform configuration, a map of
requested secret versions can be optionally supplied to have their secret data
assigned to the output.

To populate secrets with values managed by Terraform (for example, outputs from
another resource), supply `write_secret_data`. Use `write_secret_data_base64`
for binary payloads. Keys in either map must match entries in `secrets`.

```hcl
module "my_secrets" {
  source = "../modules/secrets"

  project = var.project_id
  topic   = "cloudbuild"
  secrets = ["my-api-token", "my-ssh-key", "db-password"]

  secret_accessors = [
    "serviceAccount:my-service-account@my-project.iam.gserviceaccount.com"
  ]

  read_secret_version = {
    my-api-token = "latest"
    my-ssh-key   = "1"
  }

  write_secret_data = {
    db-password = random_password.db.result
  }
}

output "my_api_token" {
  value = module.my_secrets.secret_data["my-api-token"]
}
```

## Inputs

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|:--------:|
| project | string | The project ID where secret resources are centralized. | n/a | yes |
| secrets | list(string) | Descriptive names of secrets to create. | n/a | yes |
| topic | string | Some descriptive text that will be added to the labels for this set of secrets in the project, e.g. 'cloudbuild'. | n/a | yes |
| secret_accessors | list(string) | Service accounts given permission to read secrets. | `[]` | no |
| read_secret_version | map(string) | Map of secrets and the version for which secret data is to be retrieved. For secret data to be read and used in TF configurations. | `{}` | no |
| write_secret_data | map(string) | Map of secrets and their plaintext data to write as new secret versions. Keys must match entries in `secrets`. | `{}` | no |
| write_secret_data_base64 | map(string) | Map of secrets and their base64-encoded data to write as new secret versions. Use for binary data like certificates or keys. | `{}` | no |
| deletion_policy | string | What Terraform does to the prior secret version when it is replaced (e.g. on rotation) or destroyed. One of: `DISABLE`, `DELETE`, `ABANDON`. | `"DISABLE"` | no |

## Outputs

| Name | Description |
|------|-------------|
| secret_data | Secret plaintexts. |
| secret_names | Secret names mapped to their full resource IDs. |

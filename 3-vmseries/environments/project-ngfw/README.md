## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| fw\_machine\_type | n/a | `string` | n/a | yes |
| fw\_panos | n/a | `string` | n/a | yes |
| project\_id | Project ID for Private Shared VPC. | `string` | n/a | yes |
| region | n/a | `string` | n/a | yes |
| subnets | n/a | `list(string)` | n/a | yes |
| tags | n/a | `list(string)` | n/a | yes |
| terraform\_service\_account | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_group | n/a |
| nic0\_public\_ip | n/a |
| nic1\_public\_ip | n/a |
| nic2\_public\_ip | n/a |
| vm\_names | n/a |
| vm\_self\_link | n/a |


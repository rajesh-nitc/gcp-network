## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| private\_dev | n/a | `string` | n/a | yes |
| project\_id | n/a | `string` | n/a | yes |
| region | n/a | `string` | n/a | yes |
| subnet\_dev | n/a | `string` | n/a | yes |
| subnet\_mgmt | n/a | `string` | n/a | yes |
| subnet\_trust | n/a | `string` | n/a | yes |
| subnet\_untrust | n/a | `string` | n/a | yes |
| terraform\_service\_account | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| mgmt\_network\_name | The name of the VPC being created |
| mgmt\_network\_self\_link | The URI of the VPC being created |
| subnets\_mgmt\_self\_link | The self-links of subnets being created |
| subnets\_trust\_self\_link | The self-links of subnets being created |
| subnets\_untrust\_self\_link | The self-links of subnets being created |
| trust\_network\_name | The name of the VPC being created |
| trust\_network\_self\_link | The URI of the VPC being created |
| untrust\_network\_name | The name of the VPC being created |
| untrust\_network\_self\_link | The URI of the VPC being created |


## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| google | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| health\_check | n/a | `map` | <pre>{<br>  "check_interval_sec": 1,<br>  "healthy_threshold": 4,<br>  "host": null,<br>  "port": 80,<br>  "port_name": null,<br>  "proxy_header": "NONE",<br>  "request": null,<br>  "request_path": null,<br>  "response": "",<br>  "timeout_sec": 1,<br>  "type": "tcp",<br>  "unhealthy_threshold": 5<br>}</pre> | no |
| network | n/a | `string` | n/a | yes |
| project\_id | Project ID for Private Shared VPC. | `string` | n/a | yes |
| region | n/a | `string` | n/a | yes |
| service\_account\_name | n/a | `string` | `"test-instance-sa"` | no |
| service\_account\_roles | List of IAM roles to assign to the service account. | `list(string)` | <pre>[<br>  "roles/logging.logWriter",<br>  "roles/monitoring.metricWriter",<br>  "roles/monitoring.viewer",<br>  "roles/compute.osLogin"<br>]</pre> | no |
| subnet | n/a | `string` | n/a | yes |
| terraform\_service\_account | n/a | `string` | n/a | yes |

## Outputs

No output.


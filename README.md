<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.94.1 |
| <a name="requirement_routeros"></a> [routeros](#requirement\_routeros) | 1.81.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.9.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_terraform-aws-setup"></a> [terraform-aws-setup](#module\_terraform-aws-setup) | ./modules/terraform-aws-setup | n/a |
| <a name="module_terraform-aws-state"></a> [terraform-aws-state](#module\_terraform-aws-state) | ./modules/terraform-aws-state | n/a |
| <a name="module_terraform-routeros-backup"></a> [terraform-routeros-backup](#module\_terraform-routeros-backup) | ./modules/terraform-routeros-backup | n/a |
| <a name="module_terraform-routeros-dns"></a> [terraform-routeros-dns](#module\_terraform-routeros-dns) | ./modules/terraform-routeros-dns | n/a |
| <a name="module_terraform-routeros-firewall"></a> [terraform-routeros-firewall](#module\_terraform-routeros-firewall) | ./modules/terraform-routeros-firewall | n/a |
| <a name="module_terraform-routeros-monitoring"></a> [terraform-routeros-monitoring](#module\_terraform-routeros-monitoring) | ./modules/terraform-routeros-monitoring | n/a |
| <a name="module_terraform-routeros-network"></a> [terraform-routeros-network](#module\_terraform-routeros-network) | ./modules/terraform-routeros-network | n/a |
| <a name="module_terraform-routeros-setup"></a> [terraform-routeros-setup](#module\_terraform-routeros-setup) | ./modules/terraform-routeros-setup | n/a |
| <a name="module_terraform-routeros-wifi"></a> [terraform-routeros-wifi](#module\_terraform-routeros-wifi) | ./modules/terraform-routeros-wifi | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | `"ca-west-1"` | no |
| <a name="input_cap_ax_macs"></a> [cap\_ax\_macs](#input\_cap\_ax\_macs) | List of allowed MAC addresses | `list(string)` | n/a | yes |
| <a name="input_email_address"></a> [email\_address](#input\_email\_address) | email address for monitoring alerts | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"production"` | no |
| <a name="input_project"></a> [project](#input\_project) | The project name | `string` | n/a | yes |
| <a name="input_routeros_host"></a> [routeros\_host](#input\_routeros\_host) | The Router OS host | `string` | n/a | yes |
| <a name="input_routeros_password"></a> [routeros\_password](#input\_routeros\_password) | The Router OS password | `string` | n/a | yes |
| <a name="input_routeros_username"></a> [routeros\_username](#input\_routeros\_username) | The Router OS username | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
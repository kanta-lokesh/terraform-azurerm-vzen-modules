# Zscaler Virtual Service Edge / Azure NSG Module

This module can be used to create default Management and Service interface NSG resources for Virtual Service Edge appliances. A count can be set to create once of each resource or potentially one per appliance if desired. As part of Zscaler provided deployment templates most resources have conditional create options leveraged "byo" variables should a customer want to leverage the module outputs with data reference to resources that may already exist in their Azure environment.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.108.0, <= 3.116 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.108.0, <= 3.116 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.vzen_mgmt_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.vzen_service_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.mgt_nsg_selected](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |
| [azurerm_network_security_group.service_nsg_selected](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_byo_mgmt_nsg_names"></a> [byo\_mgmt\_nsg\_names](#input\_byo\_mgmt\_nsg\_names) | Management Network Security Group ID for Virtual Service Edge association | `list(string)` | `null` | no |
| <a name="input_allow_ssh_from_existing_ips"></a> [allow\_ssh\_from\_existing\_ips](#input\_allow\_ssh\_from\_existing\_ips) | Allow SSH access from existing IPs defined in allowed_ips_for_ssh variable | `bool` | `false` | yes |
| <a name="input_allowed_ips_for_ssh"></a> [allowed\_ips\_for\_ssh](#input\_allowed\_ips\_for\_ssh) | List of existing IPs/CIDR ranges to allow SSH access to VZEN instances from | `list(string)` | `null` | yes |
| <a name="input_byo_nsg"></a> [byo\_nsg](#input\_byo\_nsg) | Bring your own network security group for Virtual Service Edge | `bool` | `false` | no |
| <a name="input_byo_service_nsg_names"></a> [byo\_service\_nsg\_names](#input\_byo\_service\_nsg\_names) | Service Network Security Group ID for Virtual Service Edge association | `list(string)` | `null` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | Populate any custom user defined tags from a map | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Virtual Service Edge Azure Region | `string` | n/a | yes |
| <a name="input_nsg_count"></a> [nsg\_count](#input\_nsg\_count) | Default number of network security groups to create | `number` | `1` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Main Resource Group Name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mgmt_nsg_id"></a> [mgmt\_nsg\_id](#output\_mgmt\_nsg\_id) | Management Network Security Group ID |
| <a name="output_service_nsg_id"></a> [service\_nsg\_id](#output\_service\_nsg\_id) | Service Network Security Group ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
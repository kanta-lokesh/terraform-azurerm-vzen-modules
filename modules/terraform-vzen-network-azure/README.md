# Zscaler Virtual Service Edge / Azure Network Infrastructure Module

This module has multi-purpose use and is leveraged by all other Zscaler Virtual Service Edge child modules in some capacity. All network infrastructure resources pertaining to connectivity dependencies for a successful Virtual Service Edge deployment in a private subnet are referenced here. Full list of resources can be found below, but in general this module will handle all Resource Group, VNet, Subnets and Public IP creations to build out a resilient Azure network architecture. Most resources also have "conditional create" capabilities where, by default, they will all be created unless instructed not to with various "byo" and "enabled" variables. Use cases are documented in more detail in each description in variables.tf as well as the terraform.tfvars example file is vzen_standalone (or) vzen_with_azure_lb.

## Private DNS Resolver Network Restrictions

<https://learn.microsoft.com/en-us/azure/dns/dns-private-resolver-overview> <br>

### Virtual network restrictions

The following restrictions hold with respect to virtual networks:

- A DNS resolver can only reference a virtual network in the same region as the DNS resolver.
- A virtual network can't be shared between multiple DNS resolvers. A single virtual network can only be referenced by a single DNS resolver.
<br>

### Subnet restrictions

Subnets used for DNS resolver have the following limitations:

- The following IP address space is reserved and can't be used for the DNS resolver service: 10.0.1.0 - 10.0.16.255.
- Do not use these class C networks or subnets within these networks for DNS resolver subnets: 10.0.1.0/24, 10.0.2.0/24, 10.0.3.0/24, 10.0.4.0/24, 10.0.5.0/24, 10.0.6.0/24, 10.0.7.0/24, 10.0.8.0/24, 10.0.9.0/24, 10.0.10.0/24, 10.0.11.0/24, 10.0.12.0/24, 10.0.13.0/24, 10.0.14.0/24, 10.0.15.0/24, 10.0.16.0/24.
- A subnet must be a minimum of /28 address space or a maximum of /24 address space.
- A subnet can't be shared between multiple DNS resolver endpoints. A single subnet can only be used by a single DNS resolver endpoint.
- All IP configurations for a DNS resolver inbound endpoint must reference the same subnet. Spanning multiple subnets in the IP configuration for a single DNS resolver inbound endpoint isn't allowed.
- The subnet used for a DNS resolver inbound endpoint must be within the virtual network referenced by the parent DNS resolver.
<br>
<br>
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.108.0, <= 3.116 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.108.0, <= 3.116 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_public_ip.vzen_mgmt_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.vzen_service_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_public_ip.vzen_lb_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.vzen_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_resource_group.rg_selected](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.vzen_subnet_selected](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet_selected](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_byo_rg"></a> [byo\_rg](#input\_byo\_rg) | Bring your own Azure Resource Group. If false, a new resource group will be created automatically | `bool` | `false` | no |
| <a name="input_byo_rg_name"></a> [byo\_rg\_name](#input\_byo\_rg\_name) | User provided existing Azure Resource Group name. This must be populated if byo\_rg variable is true | `string` | `""` | no |
| <a name="input_byo_subnet_names"></a> [byo\_subnet\_names](#input\_byo\_subnet\_names) | User provided existing Azure subnet name(s). This must be populated if byo\_subnets variable is true | `list(string)` | `null` | no |
| <a name="input_byo_subnets"></a> [byo\_subnets](#input\_byo\_subnets) | Bring your own Azure subnets for Virtual Service Edge. If false, new subnet(s) will be created automatically. Default 1 subnet for Virtual Service Edge if 1 or no zones specified. Otherwise, number of subnes created will equal number of Virtual Service Edge zones | `bool` | `false` | no |
| <a name="input_byo_vnet"></a> [byo\_vnet](#input\_byo\_vnet) | Bring your own Azure VNet for Virtual Service Edge. If false, a new VNet will be created automatically | `bool` | `false` | no |
| <a name="input_byo_vnet_name"></a> [byo\_vnet\_name](#input\_byo\_vnet\_name) | User provided existing Azure VNet name. This must be populated if byo\_vnet variable is true | `string` | `""` | no |
| <a name="input_byo_vnet_subnets_rg_name"></a> [byo\_vnet\_subnets\_rg\_name](#input\_byo\_vnet\_subnets\_rg\_name) | User provided existing Azure VNET Resource Group. This must be populated if either byo\_vnet or byo\_subnets variables are true | `string` | `""` | no |
| <a name="input_vzen_subnets"></a> [vzen\_subnets](#input\_vzen\_subnets) | Virtual Service Edge Subnets to create in VNet. This is only required if you want to override the default subnets that this code creates via network\_address\_space variable. | `list(string)` | `null` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | Populate any custom user defined tags from a map | `map(string)` | `{}` | no |
| <a name="input_lb_enabled"></a> [lb\_enabled](#input\_lb\_enabled) | Default true. Configure Public IP Address for Load Balancer Front-End Configuration.| `bool` | `true` | no |
| <a name="input_resource_location"></a> [resource\_location](#input\_resource\_location) | Virtual Service Edge Azure Region | `string` | n/a | yes |
| <a name="input_network_address_space"></a> [network\_address\_space](#input\_network\_address\_space) | VNet IP CIDR Range. All subnet resources that might get created are derived from this /16 CIDR. If you require creating a VNet smaller than /16 | `string` | `"10.11.0.0/16"` | no |
| <a name="input_private_dns_subnet"></a> [private\_dns\_subnet](#input\_private\_dns\_subnet) | Private 
| <a name="input_zones"></a> [zones](#input\_zones) | Specify which availability zone(s) to deploy VM resources in if zones\_enabled variable is set to true | `list(string)` | <pre>[<br>  "1"<br>]</pre> | no |
| <a name="input_zones_enabled"></a> [zones\_enabled](#input\_zones\_enabled) | Determine whether to provision Virtual Service Edge VMs explicitly in defined zones (if supported by the Azure region provided in the resource_location variable). If left false, Azure will automatically choose a zone and module will create an availability set resource instead for VM fault tolerance | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vzen_subnet_ids"></a> [vzen\_subnet\_ids](#output\_vzen\_subnet\_ids) | Virtual Service Edge Subnet ID |
| <a name="output_management_public_ip_address_ids"></a> [public\_management\_public\_ip\_address\_ids](#output\_public\_ip\_address) | Azure Management Public IP Address ID(s) |
| <a name="output_service_public_ip_address_ids"></a> [public\_service\_public\_ip\_address\_ids](#output\_public\_ip\_address) | Azure service Public IP Address(s) |
| <a name="output_load_balancer_public_ip_address_ids"></a> [public\_load\_balancer\_public\_ip\_address\_ids](#output\_public\_ip\_address) | Azure LB Public IP Address |
| <a name="output_management_public_ip_address"></a> [public\_management\_public\_ip\_address](#output\_public\_ip\_address) | Azure Management Public IP Address |
| <a name="output_load_balancer_public_ip_address"></a> [public\_load\_balancer\_public\_ip\_address](#output\_public\_ip\_address) | Azure LB Public IP Address |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Azure Resource Group Name |
| <a name="output_virtual_network_id"></a> [virtual\_network\_id](#output\_virtual\_network\_id) | Azure Virtual Network ID |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
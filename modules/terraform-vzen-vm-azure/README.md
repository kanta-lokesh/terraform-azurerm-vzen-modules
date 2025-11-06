# Zscaler Virtual Service Edge / Azure VM (Virtual Service Edge) Module

This module creates all the necessary VM, Network Interface, and NSG/LB associations for a successful Virtual Service Edge deployment. This module is for standalone VMs that can be deployed as a cluster behind an internal Standard Load Balancer.

## Accept Azure Marketplace Terms

As per today, Marketplace Image is only available privately.... please contact Misha for the image availability

<!-- Accept the VZEN VM image terms for the Subscription(s) where VZEN is to be deployed. This can be done via the Azure Portal, Cloud Shell or az cli / powershell with a valid admin user/service principal:

```sh
az vm image terms accept --urn zscaler1579058425289:zscaler-zia-vse:preview-zscaler-zia-vse:latest
``` -->

| Azure Cloud      | Publisher ID         | Offer/Product ID        | SKU/Plan ID       | Version                              |
|:----------------:|:--------------------:|:-----------------------:|:-----------------:|:------------------------------------:|
| private (default) | zscaler1579058425289 | zscaler-zia-vse     | preview-zscaler-zia-vse | (Latest - as of Jan, 2025) |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.108.0, <= 3.116 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.108.0, <= 3.116 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_availability_set.vzen_availability_set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |
| [azurerm_linux_virtual_machine.vzen_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.vzen_mgmt_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface.vzen_service_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_backend_address_pool_association.vzen_vm_service_nic_lb_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.vzen_mgmt_nic_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_interface_security_group_association.vzen_service_nic_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_address_pool"></a> [backend\_address\_pool](#input\_backend\_address\_pool) | Azure LB Backend Address Pool ID for NIC association | `string` | `null` | no |
| <a name="input_vzen_count"></a> [vzen\_count](#input\_vzen\_count) | The number of Virtual Service Edges to deploy.  Validation assumes max for /24 subnet but could be smaller or larger as long as subnet can accommodate | `number` | `1` | no |
| <a name="input_vzen_image_offer"></a> [vzen\_image\_offer](#input\_vzen\_image\_offer) | Azure Marketplace VZEN Image Offer | `string` | `"zscaler-zia-vse"` | no |
| <a name="input_vzen_image_publisher"></a> [vzen\_image\_publisher](#input\_vzen\_image\_publisher) | Azure Marketplace VZEN Image Publisher | `string` | `"zscaler1579058425289"` | no |
| <a name="input_vzen_image_sku"></a> [vzen\_image\_sku](#input\_vzen\_image\_sku) | Azure Marketplace VZEN Image SKU | `string` | `preview-zscaler-zia-vse"` | no |
| <a name="input_vzen_image_version"></a> [vzen\_image\_version](#input\_vzen\_image\_version) | Azure Marketplace VZEN Image Version | `string` | `"latest"` | no |
| <a name="input_vzen_source_image_id"></a> [vzen\_source\_image\_id](#input\_vzen\_source\_image\_id) | Custom Virtual Service Edge Source Image ID. Set this value to the path of a local subscription Microsoft.Compute image to override the Virtual Service Edge deployment instead of using the marketplace publisher | `string` | `null` | no |
| <a name="input_vzen_vm_size"></a> [vzen\_vm\_size](#input\_vzen\_vzen\_size) | VZEN VM Size (If you want 64GB RAM size variants please use "Standard_E8-4as_v4" or "Standard_E8-4ads_v5") | `string` | `Standard_A4m_v2` | no |
| <a name="input_global_tags"></a> [global\_tags](#input\_global\_tags) | Populate any custom user defined tags from a map | `map(string)` | `{}` | no |
| <a name="input_resource_location"></a> [resource_location](#input\r_resource_\_location) | Virtual Service Edge Azure Region | `string` | n/a | yes |
| <a name="input_mgmt_nsg_id"></a> [mgmt\_nsg\_id](#input\_mgmt\_nsg\_id) | Virtual Service Edge management interface nsg id | `list(string)` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Main Resource Group Name | `string` | n/a | yes |
| <a name="input_service_nsg_id"></a> [service\_nsg\_id](#input\_service\_nsg\_id) | Virtual Service Edge service interface(s) nsg id | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_service\_subnet\_id) | Virtual Service Edge subnet id(s) | `list(string)` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Key for instances | `string` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Cloud Init data | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | Specify which availability zone(s) to deploy VM resources in if zones\_enabled variable is set to true | `list(string)` | <pre>[<br>  "1"<br>]</pre> | no |
| <a name="input_zones_enabled"></a> [zones\_enabled](#input\_zones\_enabled) | Determine whether to provision Virtual Service Edge VMs explicitly in defined zones (if supported by the Azure region provided in the location variable). If left false, Azure will automatically choose a zone and module will create an availability set resource instead for VM fault tolerance | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Instance Management Interface Private IP Address |
| <a name="output_service_ip"></a> [service\_ip](#output\_service\_ip) | Instance Service Interface Private IP Address |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
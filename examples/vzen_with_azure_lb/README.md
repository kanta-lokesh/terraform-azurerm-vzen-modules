# Zscaler "vzen_with_azure_lb" deployment type

This example deploys a Virtual Service Edge (VZEN) cluster with Azure Load Balancer suitable for environments requiring scaling and redundancy. By default, it will create a new Resource Group; 1 VNet; 1 VZEN private subnet; 2 NIC; 2 Public IP Address association to the VZEN NICs; 2 NSG each for management and service NIC respectively; generates local key pair .pem file for ssh access;  1 Standard Azure Load Balancer with all rules, probes, 1 Public IP Address for Load Balancer Frontend configuration.<br>

The number of VZENs can be customized via a "vzen_count" variable.<br>

**Note:** By default SSH to the VZEN(s) is allowed from VNET only, please check allow_ssh_from_existing_ips variable in .tfvars to override this.<br>

There are conditional create options for a few dependent resources (Resource Group, VNet, Subnets, NSGs). The "byo" variables mentioned in terraform.tfvars allow for reuse of existing resources instead of creating new ones.

## How to deploy:

Modify/populate any required variable input values in examples/vzen_standalone/terraform.tfvars file and save, then export the following variables.

- ARM_SUBSCRIPTION_ID=`<your_azure_subscription_id>`
- ARM_TENANT_ID=`<your_azue_tenant_id>`
- ARM_CLIENT_ID=`<your_azue_client_id>`
- ARM_CLIENT_SECRET=`<your_azure_client_secret>`

From vzen_standalone directory execute:
- terraform init
- terraform plan
- terraform apply

## How to destroy:
Export the following variables.

- ARM_SUBSCRIPTION_ID=`<your_azure_subscription_id>`
- ARM_TENANT_ID=`<your_azue_tenant_id>`
- ARM_CLIENT_ID=`<your_azue_client_id>`
- ARM_CLIENT_SECRET=`<your_azure_client_secret>`

From vzen_with_azure_lb directory execute:
- terraform destroy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.108.0, <= 3.116 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.3.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 3.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vzen_nsg"></a> [vzen\_nsg](#module\_vzen\_nsg) | ../../modules/terraform-vzen-nsg-azure | n/a |
| <a name="module_vzen_vm"></a> [vzen\_vm](#module\_vzen\_vm) | ../../modules/terraform-vzen-vm-azure | n/a |
| <a name="module_network"></a> [network](#module\_network) | ../../modules/terraform-vzen-network-azure | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.testbed](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.user_data_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_location"></a> [resource\_location](#input\_resource\_location) | The Azure Region where resources are to be deployed | `string` | `"westus2"` | yes |
| <a name="input_vzen_count"></a> [vzen\_count](#input\_vzen\_count) | The number of VZENs to deploy.  Validation assumes max for /24 subnet but could be smaller or larger as long as subnet can accommodate | `number` | `2` | yes |
| <a name="input_allow_ssh_from_existing_ips"></a> [allow\_ssh\_from\_existing\_ips](#input\_allow\_ssh\_from\_existing\_ips) | Allow SSH access from existing IPs defined in allowed_ips_for_ssh variable | `bool` | `false` | yes |
| <a name="input_allowed_ips_for_ssh"></a> [allowed\_ips\_for\_ssh](#input\_allowed\_ips\_for\_ssh) | List of existing IPs/CIDR ranges to allow SSH access to VZEN instances from | `list(string)` | `null` | yes |
| <a name="input_vzen_subnets"></a> [vzen\_subnets](#input\_vzen\_subnets) | VZEN Subnets to create in VNet. This is only required if you want to override the default subnets that this code creates | `list(string)` | `null` | no |
| <a name="input_vzen_image_offer"></a> [vzen\_image\_offer](#input\_vzen\_image\_offer) | Azure Marketplace VZEN Image Offer | `string` | `"zscaler-zia-vse"` | no |
| <a name="input_vzen_image_publisher"></a> [vzen\_image\_publisher](#input\_vzen\_image\_publisher) | Azure Marketplace VZEN Image Publisher | `string` | `"zscaler1579058425289"` | no |
| <a name="input_vzen_image_sku"></a> [vzen\_image\_sku](#input\_vzen\_image\_sku) | Azure Marketplace VZEN Image SKU | `string` | `preview-zscaler-zia-vse"` | no |
| <a name="input_vzen_image_version"></a> [vzen\_image\_version](#input\_vzen\_image\_version) | Azure Marketplace VZEN Image Version | `string` | `"latest"` | no |
| <a name="input_vzen_vm_size"></a> [vzen\_vm\_size](#input\_vzen\_vzen\_size) | VZEN VM Size (If you want 64GB RAM size variants please use "Standard_E8-4as_v4" or "Standard_E8-4ads_v5") | `string` | `Standard_A4m_v2` | yes |
| <a name="input_vzen_source_image_id"></a> [vzen\_source\_image\_id](#input\_vzen\_source\_image\_id) | Custom VZEN Source Image ID. Set this value to the path of a local subscription Microsoft.Compute image to override the VZEN deployment instead of using the marketplace publisher | `string` | `null` | no |
| <a name="input_env_subscription_id"></a> [env\_subscription\_id](#input\_env\_subscription\_id) | Azure Subscription ID where resources are to be deployed in | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Customer defined environment tag. ie: Dev, QA, Prod, etc. | `string` | `"Development"` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | The interval, in seconds, for how frequently to probe the endpoint for health status. Typically, the interval is slightly less than half the allocated timeout period (in seconds) which allows two full probes before taking the instance out of rotation. The default value is 15, the minimum value is 5 | `number` | `15` | no |
| <a name="input_network_address_space"></a> [network\_address\_space](#input\_network\_address\_space) | VNET CIDR / address prefix | `string` | `"10.11.0.0/16"` | no |
| <a name="input_number_of_probes"></a> [number\_of\_probes](#input\_number\_of\_probes) | The number of probes where if no response, will result in stopping further traffic from being delivered to the endpoint. This values allows endpoints to be taken out of rotation faster or slower than the typical times used in Azure | `number` | `1` | no |
| <a name="input_owner_tag"></a> [owner\_tag](#input\_owner\_tag) | Customer defined owner tag value. ie: Org, Dept, username, etc. | `string` | `"vzen-admin"` | no |
| <a name="input_probe_threshold"></a> [probe\_threshold](#input\_probe\_threshold) | The number of consecutive successful or failed probes in order to allow or deny traffic from being delivered to this endpoint. After failing the number of consecutive probes equal to this value, the endpoint will be taken out of rotation and require the same number of successful consecutive probes to be placed back in rotation. | `number` | `2` | no |
| <a name="input_reuse_nsg"></a> [reuse\_nsg](#input\_reuse\_nsg) | Specifies whether the NSG module should create 1:1 network security groups per instance or 1 network security group for all instances | `bool` | `"false"` | yes |
| <a name="input_tls_key_algorithm"></a> [tls\_key\_algorithm](#input\_tls\_key\_algorithm) | algorithm for tls\_private\_key resource | `string` | `"RSA"` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | Specify which availability zone(s) to deploy VM resources in if zones\_enabled variable is set to true | `list(string)` | <pre>[<br>  "1"<br>]</pre> | yes |
| <a name="input_zones_enabled"></a> [zones\_enabled](#input\_zones\_enabled) | Determine whether to provision VZEN VMs explicitly in defined zones (if supported by the Azure region provided in the location variable). If left false, Azure will automatically choose a zone and module will create an availability set resource instead for VM fault tolerance | `bool` | `false` | yes |
| <a name="input_byo_rg"></a> [byo\_rg](#input\_byo\_rg) | Bring your own Azure Resource Group. If false, a new resource group will be created automatically | `bool` | `false` | no |
| <a name="input_byo_rg_name"></a> [byo\_rg\_name](#input\_byo\_rg\_name) | User provided existing Azure Resource Group name. This must be populated if byo\_rg variable is true | `string` | `""` | no |
| <a name="input_byo_vnet"></a> [byo\_vnet](#input\_byo\_vnet) | Bring your own Azure VNet for VZEN. If false, a new VNet will be created automatically | `bool` | `false` | no |
| <a name="input_byo_vnet_name"></a> [byo\_vnet\_name](#input\_byo\_vnet\_name) | User provided existing Azure VNet name. This must be populated if byo\_vnet variable is true | `string` | `""` | no |
| <a name="input_byo_subnet_names"></a> [byo\_subnet\_names](#input\_byo\_subnet\_names) | User provided existing Azure subnet name(s). This must be populated if byo\_subnets variable is true | `list(string)` | `null` | no |
| <a name="input_byo_subnets"></a> [byo\_subnets](#input\_byo\_subnets) | Bring your own Azure subnets for VZEN. If false, new subnet(s) will be created automatically. Default 1 subnet for VZEN if 1 or no zones specified. Otherwise, number of subnes created will equal number of VZEN zones | `bool` | `false` | no |
| <a name="input_byo_vnet_subnets_rg_name"></a> [byo\_vnet\_subnets\_rg\_name](#input\_byo\_vnet\_subnets\_rg\_name) | User provided existing Azure VNET Resource Group. This must be populated if either byo\_vnet or byo\_subnets variables are true | `string` | `""` | no |
| <a name="input_byo_nsg"></a> [byo\_nsg](#input\_byo\_nsg) | Bring your own Network Security Groups for VZEN | `bool` | `false` | no |
| <a name="input_byo_nsg_rg"></a> [byo\_nsg\_rg](#input\_byo\_nsg\_rg) | User provided existing NSG Resource Group. This must be populated if byo\_nsg variable is true | `string` | `""` | no |
| <a name="input_byo_mgmt_nsg_names"></a> [byo\_mgmt\_nsg\_names](#input\_byo\_mgmt\_nsg\_names) | Existing Management Network Security Group IDs for VZEN VM association. This must be populated if byo\_nsg variable is true | `list(string)` | `null` | no |
| <a name="input_byo_service_nsg_names"></a> [byo\_service\_nsg\_names](#input\_byo\_service\_nsg\_names) | Existing Service Network Security Group IDs for VZEN VM association. This must be populated if byo\_nsg variable is true | `list(string)` | `null` | no |
## Outputs

| Name | Description | Type |
|------|-------------|------|
| <a name="output_arm_resource_group"></a> [arm\_resource\_group](#output\_arm\_resource\_group) | Resource group name in which VZEN vm(s) | `string` |
| <a name="output_management_public_ip_addresses"></a> [management\_public\_ip\_addresses](#output\_management\_public\_ip\_addresses) | Management Public IP of VZEN vm(s) | `list(string)` |
| <a name="output_loadbalancer_public_ip_addresses"></a> [loadbalancer\_public\_ip\_addresses](#output\_loadbalancer\_public\_ip\_addresses) | LoadBalancer Public IP of Cluster VZEN vm's | `string` |
| <a name="output_ssh_key_path"></a> [ssh\_key\_path](#output\_ssh\_key\_path) | SSH private key path to VZEN vm(s) | `string` |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
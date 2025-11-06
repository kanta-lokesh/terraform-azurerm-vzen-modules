variable "env_subscription_id" {
  type        = string
  description = "Azure Subscription ID where resources are to be deployed in"
  sensitive   = true
}

variable "user_defined_tags" {
  type        = map(string)
  description = "Customer defined environment tags Ex. { Product : 'VZEN' ,Type : 'Cluster', Vendor : 'Zscaler' }"
  default     = {}
}

variable "resource_location" {
  type        = string
  description = "Azure Region"
}

variable "vzen_count" {
  type        = number
  default     = 2
}

variable "allow_ssh_from_existing_ips" {
  type        = bool
  description = "Allow SSH access from existing IPs defined in allowed_ips_for_ssh variable"
  default     = false
}

variable "allowed_ips_for_ssh" {
  type        = list(string)
  description = "List of existing IPs/CIDR ranges to allow SSH access to VZEN instances from"
  default     = []
}

variable "network_address_space" {
  type        = string
  description = "VNet IP CIDR Range. All subnet resources that might get created are derived from this /16 CIDR."
  default     = "10.11.0.0/16"
  validation {
    condition     = (can(cidrhost(var.network_address_space, 0)) &&
    try(cidrhost(var.network_address_space, 0), null) == split("/", var.network_address_space)[0] )
    error_message = "Must be a valid IPv4 CIDR."
  }
}

locals {
  az_supported_regions = ["australiaeast", "Australia East", "brazilsouth", "Brazil South", "canadacentral", "Canada Central", "centralindia", "Central India", "centralus", "Central US", "chinanorth3", "China North 3", "ChinaNorth3", "eastasia", "East Asia", "eastus", "East US", "eastus2", "East US 2", "francecentral", "France Central", "germanywestcentral", "Germany West Central", "japaneast", "Japan East", "koreacentral", "Korea Central", "northeurope", "North Europe", "norwayeast", "Norway East", "southafricanorth", "South Africa North", "southcentralus", "South Central US", "southeastasia", "Southeast Asia", "swedencentral", "Sweden Central", "switzerlandnorth", "Switzerland North", "uaenorth", "UAE North", "uksouth", "UK South", "westeurope", "West Europe", "westus2", "West US 2", "westus3", "West US 3", "usgovvirginia", "US Gov Virginia"]
  zones_supported = (
    contains(local.az_supported_regions, var.resource_location) && var.zones_enabled == true
  )
}

variable "zones_enabled" {
  type        = bool
  description = "Determine whether to provision VZEN VMs explicitly in defined zones (if supported by the Azure region provided in the location variable). If left false, Azure will automatically choose a zone and module will create an availability set resource instead for VM fault tolerance"
  default     = false
}

variable "zones" {
  type        = list(string)
  description = "Specify which availability zone(s) to deploy VM resources in if zones_enabled variable is set to true"
  default     = ["1"]
  validation {
    condition = (
      !contains([for zones in var.zones : contains(["1", "2", "3"], zones)], false)
    )
    error_message = "Input zones variable must be a number 1-3."
  }
}

variable "tls_key_algorithm" {
  type        = string
  description = "algorithm for tls_private_key resource"
  default     = "RSA"
}

variable "vzen_subnets" {
  type        = list(string)
  description = "VZEN Subnets to create in VNet. This is only required if you want to override the default subnets that this code creates"
  default     = null
}

variable "reuse_nsg" {
  type        = bool
  description = "Specifies whether the NSG module should create 1:1 network security groups per instance or 1 network security group for all instances"
  default     = "false"
}

variable "vzen_image_publisher" {
  type        = string
  description = "Azure Marketplace VZEN Image Publisher"
  default     = "zscaler1579058425289"
}

variable "vzen_image_offer" {
  type        = string
  description = "Azure Marketplace VZEN Image Offer"
  default     = "preview-zscaler-zia-vse-preview"
}

variable "vzen_image_sku" {
  type        = string
  description = "Azure Marketplace VZEN Image SKU"
  default     = "preview-zia-vse"
}

variable "vzen_image_version" {
  type        = string
  description = "Azure Marketplace VZEN Image Version"
  default     = "latest"
}

variable "vzen_source_image_id" {
  type        = string
  description = "Custom VZEN Source Image ID. Set this value to the path of a local subscription Microsoft.Compute image to override the VZEN deployment instead of using the marketplace publisher"
  default     = null
}

variable "vzen_vm_size" {
  type        = string
  description = "Azure VM Size for VZEN VM"
  default     = "Standard_A4m_v2"

  validation {
    condition = (
      var.vzen_vm_size == "Standard_A4m_v2" ||
      var.vzen_vm_size == "Standard_E8-4ads_v5" ||
      var.vzen_vm_size == "Standard_E8-4as_v4"
    )
    error_message = "VZEN VM size must be one of the following: Standard_A4m_v2, Standard_E8-4ads_v5, Standard_E8-4as_v4\nUse Standard_A4m_v2 for 32GB RAM.\n USE Standard_E8-4ads_v5 or Standard_E8-4as_v4 for 64GB RAM.\n"
  }
}

variable "lb_enabled" {
  type        = bool
  description = "Default false, set to true if it's a LB deployment (vzen_with_azure_lb)"
  default     = true
}

variable "health_check_interval" {
  type        = number
  description = "The interval, in seconds, for how frequently to probe the endpoint for health status. Typically, the interval is slightly less than half the allocated timeout period (in seconds) which allows two full probes before taking the instance out of rotation. The default value is 15, the minimum value is 5"
  default     = 15
  validation {
    condition = (
      var.health_check_interval > 4
    )
    error_message = "Input health_check_interval must be a number 5 or greater."
  }
}

variable "probe_threshold" {
  type        = number
  description = "The number of consecutive successful or failed probes in order to allow or deny traffic from being delivered to this endpoint. After failing the number of consecutive probes equal to this value, the endpoint will be taken out of rotation and require the same number of successful consecutive probes to be placed back in rotation."
  default     = 2
}

variable "number_of_probes" {
  type        = number
  description = "The number of probes where if no response, will result in stopping further traffic from being delivered to the endpoint. This values allows endpoints to be taken out of rotation faster or slower than the typical times used in Azure"
  default     = 1
}

variable "lb_health_port" {
  type        = number
  description = "Port number for Azure LB"
  default     = 80
  validation {
    condition = (
      (tonumber(var.lb_health_port) >= 80 && tonumber(var.lb_health_port) <= 65535)
    )
    error_message = "Input lb_health_port must be set to a single value between 80-65535."
  }
}

variable "byo_rg" {
  type        = bool
  description = "Bring your own Azure Resource Group. If false, a new resource group will be created automatically"
  default     = false
}

variable "byo_rg_name" {
  type        = string
  description = "User provided existing Azure Resource Group name. This must be populated if byo_rg variable is true"
  default     = ""
}

variable "byo_vnet" {
  type        = bool
  description = "Bring your own Azure VNet for VZEN. If false, a new VNet will be created automatically"
  default     = false
}

variable "byo_vnet_name" {
  type        = string
  description = "User provided existing Azure VNet name. This must be populated if byo_vnet variable is true"
  default     = ""
}

variable "byo_subnets" {
  type        = bool
  description = "Bring your own Azure subnets for VZEN. If false, new subnet(s) will be created automatically. Default 1 subnet for VZEN if 1 or no zones specified. Otherwise, number of subnes created will equal number of VZEN zones"
  default     = false
}

variable "byo_subnet_names" {
  type        = list(string)
  description = "User provided existing Azure subnet name(s). This must be populated if byo_subnets variable is true"
  default     = null
}

variable "byo_vnet_subnets_rg_name" {
  type        = string
  description = "User provided existing Azure VNET Resource Group. This must be populated if either byo_vnet or byo_subnets variables are true"
  default     = ""
}

variable "byo_nsg" {
  type        = bool
  description = "Bring your own Network Security Groups for VZEN"
  default     = false
}

variable "byo_nsg_rg" {
  type        = string
  description = "User provided existing NSG Resource Group. This must be populated if byo_nsg variable is true"
  default     = ""
}

variable "byo_mgmt_nsg_names" {
  type        = list(string)
  description = "Existing Management Network Security Group IDs for VZEN VM association. This must be populated if byo_nsg variable is true"
  default     = null
}

variable "byo_service_nsg_names" {
  type        = list(string)
  description = "Existing Service Network Security Group ID for VZEN VM association. This must be populated if byo_nsg variable is true"
  default     = null
}
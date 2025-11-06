
variable "resource_location" {
  type        = string
  description = "Azure Region"
}

variable "resource_tag" {
  type        = string
  description = "A tag to associate to all the network module resources"
  default     = null
}

variable "global_tags" {
  type        = map(string)
  description = "Populate any custom user defined tags from a map"
  default     = {}
}

variable "vzen_count" {
  type        = number
  default     = 1
}

variable "network_address_space" {
  type        = string
  description = "VNet IP CIDR Range."
  default     = "10.11.0.0/16"
  validation {
    condition     = (can(cidrhost(var.network_address_space, 0)) &&
    try(cidrhost(var.network_address_space, 0), null) == split("/", var.network_address_space)[0] )
    error_message = "Must be a valid IPv4 CIDR."
  }
}

variable "vzen_subnets" {
  type        = list(string)
  description = "VZEN Subnets to create in VNet. This is only required if you want to override the default subnets that this code creates"
  default     = null
}

# Validation to determine if Azure Region selected supports availabilty zones if desired
locals {
  az_supported_regions = ["australiaeast", "Australia East", "brazilsouth", "Brazil South", "canadacentral", "Canada Central", "centralindia", "Central India", "centralus", "Central US", "chinanorth3", "China North 3", "ChinaNorth3", "eastasia", "East Asia", "eastus", "East US", "eastus2", "East US 2", "francecentral", "France Central", "germanywestcentral", "Germany West Central", "japaneast", "Japan East", "koreacentral", "Korea Central", "northeurope", "North Europe", "norwayeast", "Norway East", "southafricanorth", "South Africa North", "southcentralus", "South Central US", "southeastasia", "Southeast Asia", "swedencentral", "Sweden Central", "switzerlandnorth", "Switzerland North", "uaenorth", "UAE North", "uksouth", "UK South", "westeurope", "West Europe", "westus2", "West US 2", "westus3", "West US 3", "usgovvirginia", "US Gov Virginia"]
  zones_supported = (
    contains(local.az_supported_regions, var.resource_location) && var.zones_enabled == true
  )
  frontend_zone_specific = length(var.zones) == 1 ? var.zones : ["1", "2", "3"] 
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

variable "lb_enabled" {
  type        = bool
  description = "Default false, set to true if it's a LB deployment (vzen_with_azure_lb)"
  default     = false
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

variable "byo_vnet_subnets_rg_name" {
  type        = string
  description = "User provided existing Azure VNET Resource Group. This must be populated if either byo_vnet or byo_subnets variables are true"
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

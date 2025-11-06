variable "resource_group" {
  type        = string
  description = "Main Resource Group Name"
}

variable "resource_tag" {
  type        = string
  description = "A tag to associate to all the network module resources"
  default     = null
}

variable "resource_location" {
  type        = string
  description = "VZEN Azure Region"
}

variable "global_tags" {
  type        = map(string)
  description = "Populate any custom user defined tags from a map"
  default     = {}
}

variable "ssh_key" {
  type        = string
  description = "SSH Key for instances"
}

variable "vzen_image_publisher" {
  type        = string
  description = "Azure Marketplace VZEN Image Publisher"
  default     = "zscaler1579058425289"
}

variable "vzen_image_offer" {
  type        = string
  description = "Azure Marketplace VZEN Image Offer"
  default     = "zscaler-zia-vse"
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

variable "vzen_count" {
  type        = number
  description = "The number of VZENs to deploy.  Validation assumes max for /24 subnet but could be smaller or larger as long as subnet can accommodate"
  default     = 1
  validation {
    condition     = var.vzen_count >= 1 && var.vzen_count <= 250
    error_message = "Input vzen_count must be a whole number between 1 and 250."
  }
}

variable "mgmt_nsg_id" {
  type        = list(string)
  description = "VZEN management interface nsg id"
}

variable "service_nsg_id" {
  type        = list(string)
  description = "VZEN service interface(s) nsg id"
}

variable "subnet_ids" {
  type        = list(string)
  description = "VZEN management subnet id. "
}

variable "management_public_ip" {
  type        = list(string)
  description = "VZEN management public ip."
}

variable "service_public_ip" {
  type        = list(string)
  description = "VZEN management service ip."
}

variable "lb_enabled" {
  type        = bool
  description = "Default false, set to true if it's a LB deployment (vzen_with_azure_lb)"
  default     = false
}

variable "backend_address_pool" {
  type        = string
  description = "Azure LB Backend Address Pool ID for NIC association"
  default     = null
}

# Validation to determine if Azure Region selected supports availabilty zones if desired
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

locals {
  max_fd_supported_regions = ["eastus", "East US", "eastus2", "East US 2", "westus", "West US", "centralus", "Central US", "northcentralus", "North Central US", "southcentralus", "South Central US", "canadacentral", "Canada Central", "northeurope", "North Europe", "westeurope", "West Europe"]
  max_fd_supported = (
    contains(local.max_fd_supported_regions, var.resource_location) && var.zones_enabled == false
  )
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
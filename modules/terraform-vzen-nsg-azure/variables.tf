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
  description = "Azure Region"
}

variable "global_tags" {
  type        = map(string)
  description = "Populate any custom user defined tags from a map"
  default     = {}
}

variable "nsg_count" {
  type        = number
  description = "Default number of network security groups to create"
  default     = 1
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

variable "byo_nsg" {
  type        = bool
  description = "Bring your own network security group for VZEN"
  default     = false
}

variable "byo_mgmt_nsg_names" {
  type        = list(string)
  description = "Management Network Security Group ID for VZEN association"
  default     = null
}

variable "byo_service_nsg_names" {
  type        = list(string)
  description = "Service Network Security Group ID for VZEN association"
  default     = null
}
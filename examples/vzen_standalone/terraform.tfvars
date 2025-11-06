# Uncomment the lines and fill in appropriate details as needed

######################################################################################################################
# please enter the subscription ID in which you want to deploy the resources                                         #
# Eg: abc12345-6789-0123-a456-bc1234567de8                                                                           #
######################################################################################################################

# env_subscription_id                      = "abc12345-6789-0123-a456-bc1234567de8"

######################################################################################################################
# please enter the user_defined_tags variables to include in the tags to the Resources                               #
# Eg: { Product : "VZEN" ,Type : "Standalone", Vendor : "Zscaler" }                                                  #
######################################################################################################################

# user_defined_tags                        = { Product : "VZEN" ,Type : "Standalone", Vendor : "Zscaler" }

######################################################################################################################
# ZSCALER Cloud Name - Mandatory                                                                                     #
# Provide the Zscaler cloud Name.                                                                                    #
# Valid Cloud Names: "zscloud.net" "zscaler.net" "zscalertwo.net" "zscalerthree.net" "zscalerten.net"                #
# "zscalergov.net" "zscalerbeta.net" "zspreview.net" "zsprotect.net" "zsdemo.net" "zsca.net" "zsdevel.net" "zsqa.net"#
######################################################################################################################

# cloud_name                               = "zscaler.net"

######################################################################################################################
# please enter the Azure Location/Region in which you want to deploy the resources                                   #
# Eg: westus, eastus, etc./                                                                                          #
######################################################################################################################

# resource_location                        = "westus2"

######################################################################################################################
# please enter the No.of VZEN(s) you want to deploy, Default will be 2                                               #
# Eg: 2, 4, 16, etc.,                                                                                                #
######################################################################################################################

# vzen_count                               = 2

######################################################################################################################
# By Default the deployed VZEN's are only accessiable from VNET only, if you want to allow SSH from a certian IP     #
# range please set allow_ssh_from_existing_ips to true and provide IP's in allowed_ips_for_ssh variable              #
# The list may contain a single ip Ex: a.b.c.d or a whole subnet a.b.c.d/<subnetmask>                                #
######################################################################################################################

# allow_ssh_from_existing_ips              = false

# allowed_ips_for_ssh                      = ["IP1", "IP2"]

######################################################################################################################
# please set zones_enabled totrue if you want to deploy VZEN(s) in multiple Zones, Default: "false"                  #
# Please select the "zones" in which you want to deploy, edit this if zone_enabled is set to true                    #
# Eg: ["1", "2"], ["2", "3"], ["1", "3"], ["1"], ["2"], ["3"], ["1", "2", "3"] Default: ["1"]                        #
######################################################################################################################

# zones_enabled                            = false

# zones                                    = ["1"]

######################################################################################################################
# please set reuse_nsg to true if you want to use same Network Security Group to all of your VZEN(s), if it is set to#
# false terraform will create separate NSG for each VZEN, Default: false                                             #
# nsg_count, Default: 1. change the value in order to create multiple NSGs                                           #
######################################################################################################################

# reuse_nsg                                = false

# nsg_count                                = 1

######################################################################################################################
# By Default Terraform uses the latest VZEN marketplace image, change this if you have a VZEN image available in your#
# azure account (Please Note that the Image has to be present in resource_location in which you want to deploy the   #
# resources)                                                                                                         #
# Eg: /subscriptions/<sub-id>/resourceGroups/<rg>/providers/Microsoft.Compute/images/vzen-image"                     #
######################################################################################################################

# vzen_source_image_id                     = "/subscriptions/abc12345-6789-0123-a456-bc1234567de8/resourceGroups/<resource_group>/providers/Microsoft.Compute/images/<vzen-image>"

######################################################################################################################
# Please select the VM size, By default VM size will be "Standard_A4m_v2"(32GB RAM).                                 #
# If you want 64GB RAM size variants please uncomment "Standard_E8-4as_v4" or "Standard_E8-4ads_v5"                  #
######################################################################################################################

# vzen_vm_size                             = "Standard_A4m_v2"
# vzen_vm_size                             = "Standard_E8-4as_v4"
# vzen_vm_size                             = "Standard_E8-4ads_v5"

######################################################################################################################
# please enter a valid CIDR block in which you want to deploy the resources  Eg: 10.99.0.0/16, Default: 10.11.0.0/16 #
######################################################################################################################

# network_address_space                    = "10.99.0.0/16"

######################################################################################################################
# please enter valid subnets in which you want to deploy the resources  Eg: ["10.99.200.0/24", "10.99.201.0/24"]     #
######################################################################################################################

# vzen_subnets                             = ["10.99.200.0/24", "10.99.201.0/24"]

######################################################################################################################
# please set byo_rg to true if you want do deploy VZEN resources in your existing Resource Group                     #
# please enter Resource Group name if you want do deploy VZEN resources in your existing Resource Group (byo_rg_name)#
######################################################################################################################

# byo_rg                                   = false

# byo_rg_name                              = "vzen42_rg"

######################################################################################################################
# please set byo_vnet to true if you want do deploy VZEN resources in your existing Virtual Network                  #
# please enter Virtual Network name if you want do deploy VZEN resources in your existing VNET (byo_vnet_name)       #
######################################################################################################################

# byo_vnet                                 = false

# byo_vnet_name                            = "existing_vnet"

######################################################################################################################
# please enter byo_vnet_subnets_rg_name if you enabled byo_vnet (and/or) byo_subnet only                             #
# please enter Resource Group name in which the existing VNET is present                                             #
######################################################################################################################

# byo_vnet_subnets_rg_name                 = "existing-vnet-rg"

######################################################################################################################
# please set byo_subnets to true if you want do deploy VZEN resources in your existing Subnets                       #
######################################################################################################################

# byo_subnets                              = false

######################################################################################################################
# please provide your existing subnets in byo_subnet_names into the list, if byo_subnet is true                      #
######################################################################################################################

# byo_subnet_names                         = ["existing_subnet_name_0", "existing_subnet_name_1"]

######################################################################################################################
# please set byo_nsg to true if you want to use your own Network Security Groups for VZEN                            #
# please enter Resource Group name in which the existing NSGs are present                                            #
######################################################################################################################

# byo_nsg                                  = false

# byo_nsg_rg                               = "existing-nsg-rg"

######################################################################################################################
# please enter the names of your existing NSGs                                                                       #
######################################################################################################################

# byo_mgmt_nsg_names                       = ["mgmt-nsg-1","mgmt-nsg-2"]

# byo_service_nsg_names                    = ["service-nsg-1","service-nsg-2"]
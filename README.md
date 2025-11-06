
<a href="https://terraform.io">
    <img src="https://raw.githubusercontent.com/hashicorp/terraform-website/master/public/img/logo-text.svg" alt="Terraform logo" title="Terraform" height="50" width="250" />
</a>
<a href="https://www.zscaler.com/">
    <img src="https://www.zscaler.com/themes/custom/zscaler/logo.svg" alt="Zscaler logo" title="Zscaler" height="50" width="250" />
</a>

Zscaler VZEN Azure Terraform Modules
===========================================================================================================

# **README for Azure Terraform**

This README serves as a quick start guide to deploy Zscaler VZEN resources in Microsoft Azure using Terraform.

## **Azure Deployment Scripts for Terraform**

Use this repository to create the deployment resources required to deploy and operate VZEN in a new or existing resource group and virtual network. The [examples directory](https://github.com/zscaler/terraform-azurerm-vzen-modules/tree/main/examples) contains complete automation scripts for both greenfield and brownfield use.

## **Prerequisites**

Our Deployment scripts are leveraging Terraform v1.1.9 which includes full binary and provider support for macOS M1 chips, but any Terraform version 0.13.7 should be generally supported.

- provider registry.terraform.io/hashicorp/azurerm v3.116.x (minimum 3.108.x)
- provider registry.terraform.io/hashicorp/random v3.3.x
- provider registry.terraform.io/hashicorp/local v2.2.x
- provider registry.terraform.io/hashicorp/null v3.1.x
- provider registry.terraform.io/providers/hashicorp/tls v3.4.x

### **Azure Requirements**

1. Azure Subscription Id [link to Azure subscriptions](https://portal.azure.com/#blade/Microsoft_Azure_Billing/SubscriptionsBlade)
2. Have/Create a Service Principal. See: [how-to-create-service-principal-portal](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal). Then Collect:
    - Application (client) ID
    - Directory (tenant) ID
    - Client Secret Value
3. Azure Region (e.g. westus2) where VZEN resources are to be deployed
4. Install [Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### **Zscaler requirements**

5. Must have Zscaler VZEN SKUs Subscription.

## **Examples** 

The examples section covers two deployment templates:

Use the [**Custom Deployment template with Azure Load Balancer**](examples/vzen_with_azure_lb)
to deploy your VZEN with resources (Resource Group, VNET, Subnets, NSGs, Public IPs, Load Balancer) and load balance traffic across multiple VZENs. You can use "byo" variables to deploy VZEN with existing resources. Zscaler's recommended deployment method is Azure Load Balancer. Azure Load Balancer distributes traffic across multiple VZENs and achieves high availability.

Use the [**Custom Deployment template without Azure Load Balancer**](examples/vzen_standalone) to deploy your VZENs with resources (Resource Group, VNET, Subnets, NSGs, Public IPs) without load balancing capablities. You can use "byo" variables to deploy VZEN with existing resources.

> **Note:** The [**examples**](examples) provided in this document illustrate the usage of the various [**modules**](modules). You are encouraged to reuse and adapt these [**modules**](modules) as per your specific requirements to suit your use case.

# Azure Storage Account blob container

This is an example for setting-up a storage account container.
This example

- Sets the different Azure Region representation (location, location_short, location_cli ...) --> module "regions"
- Instanciates a map object with the common Tags ot be applied to all resources --> module "base_tagging"
- A resource-group --> module "resource_group"
- Creates a storage account 
- Creates a container --> module "containerone"

## Main.tf file content

Please replace the modules source and version with your relevant information

```hcl
#checkov:skip=CKV_AZURE_59: Access to storage account limited to virtual network only

locals {
  stack             = "container"
  landing_zone_slug = "ctx"
  location          = "westeurope"

  # extra tags value if needed
  extra_tags = {
    tag1 = "FirstTag",
    tag2 = "SecondTag"
  }

  # Base tagging values
  environment     = "sbx"
  application     = "terra-module"
  cost_center     = "CCT"
  change          = "CHG666"
  owner           = "Fabrice"
  spoc            = "Fabrice"
  tlp_colour      = "WHITE"
  cia_rating      = "C1I1A3"
  technical_owner = "Fabrice"

  #### Container 

  container_name        = "mycontainerone"
  container_access_type = "private"
  metadata = {
    "keyone" : "Foo",
    "keytwo" : "Bar"
  }

}

module "regions" {
  source       = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module?ref=master"
  azure_region = local.location
}

module "base_tagging" {
  source          = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module?ref=master"
  environment     = local.environment
  application     = local.application
  cost_center     = local.cost_center
  change          = local.change
  owner           = local.owner
  spoc            = local.spoc
  tlp_colour      = local.tlp_colour
  cia_rating      = local.cia_rating
  technical_owner = local.technical_owner
}

module "resource_group" {
  source            = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module?ref=master"
  stack             = local.stack
  landing_zone_slug = local.landing_zone_slug
  default_tags      = module.base_tagging.base_tags
  location          = module.regions.location
  location_short    = module.regions.location_short
}

module "diag_log_analytics_workspace" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-loganalyticsworkspace//module?ref=master"
  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name
  default_tags        = module.base_tagging.base_tags
}

module "storage_account" {
  source              = "git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-blobstorage//module?ref=master"
  landing_zone_slug   = local.landing_zone_slug
  stack               = local.stack
  default_tags        = module.base_tagging.base_tags
  extra_tags          = local.extra_tags
  location            = module.regions.location
  location_short      = module.regions.location_short
  resource_group_name = module.resource_group.resource_group_name

  diag_log_analytics_workspace_id = module.diag_log_analytics_workspace.log_analytics_workspace_id

  large_file_share_enabled        = true
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  enable_private_endpoint = false

  network_acls = {
    bypass                     = ["Logging", "Metrics", "AzureServices"]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

}

# Please specify source as git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/<<ADD_MODULE_NAME>>//module?ref=master or with specific tag
module "containerone" {
  source = "../../module"

  container_name        = local.container_name
  storage_account_name  = module.storage_account.storage_account_name
  container_access_type = local.container_access_type
  metadata              = local.metadata
}
```

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_base_tagging"></a> [base\_tagging](#module\_base\_tagging) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-basetagging//module | master |
| <a name="module_containerone"></a> [containerone](#module\_containerone) | ../../module | n/a |
| <a name="module_diag_log_analytics_workspace"></a> [diag\_log\_analytics\_workspace](#module\_diag\_log\_analytics\_workspace) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-loganalyticsworkspace//module | master |
| <a name="module_regions"></a> [regions](#module\_regions) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-regions//module | master |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-resourcegroup//module | master |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | git::ssh://git@ssh.dev.azure.com/v3/ECTL-AZURE/ECTL-Terraform-Modules/terraform-azurerm-blobstorage//module | master |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_has_immutability_policy"></a> [has\_immutability\_policy](#output\_has\_immutability\_policy) | Is there an Immutability Policy configured on this Storage Container? |
| <a name="output_has_legal_hold"></a> [has\_legal\_hold](#output\_has\_legal\_hold) | Is there a Legal Hold configured on this Storage Container? |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Storage Container. |
| <a name="output_name"></a> [name](#output\_name) | Resource name |
| <a name="output_resource_manager_id"></a> [resource\_manager\_id](#output\_resource\_manager\_id) | The Resource Manager ID of this Storage Container. |
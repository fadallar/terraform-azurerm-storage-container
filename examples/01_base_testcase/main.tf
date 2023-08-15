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
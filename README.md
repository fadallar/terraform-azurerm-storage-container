<!-- BEGIN_AUTOMATED_TF_DOCS_BLOCK -->
# Azure Storage Account Blob container

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)

This module creates a blob container in an existing storage account

## Examples

[01\_base\_testcase](./examples/01\_base\_testcase/README.md)

## Usage

Basic usage of this module is as follows:

```hcl
module "example" {
   source  = "<module-path>"

   # Required variables
   container_name =
   storage_account_name =

   # Optional variables
   container_access_type = "private"
   metadata = {}
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.61.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.4.3 |

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Name of the container | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of the parent storage account | `string` | n/a | yes |
| <a name="input_container_access_type"></a> [container\_access\_type](#input\_container\_access\_type) | The Access Level configured for this Container. Possible values are blob, container or private. | `string` | `"private"` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | A mapping of MetaData for this Container. All metadata keys should be lowercase. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_has_immutability_policy"></a> [has\_immutability\_policy](#output\_has\_immutability\_policy) | Is there an Immutability Policy configured on this Storage Container? |
| <a name="output_has_legal_hold"></a> [has\_legal\_hold](#output\_has\_legal\_hold) | Is there a Legal Hold configured on this Storage Container? |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Storage Container. |
| <a name="output_name"></a> [name](#output\_name) | Resource name |
| <a name="output_resource_manager_id"></a> [resource\_manager\_id](#output\_resource\_manager\_id) | The Resource Manager ID of this Storage Container. |

## Contact

Atos

to regenerate this `README.md` file run in pwsh, in current directory:

`docker run --rm -v "$($pwd.path):/data" cytopia/terraform-docs terraform-docs-012 -c tfdocs-config.yml ./module`

`docker run --rm --name pre -v "$($pwd.path):/lint" -w /lint ghcr.io/antonbabenko/pre-commit-terraform run -a`

`docker stop pre; docker rm pre; docker run --name pre -v "$($pwd.path):/lint" -w /lint ghcr.io/antonbabenko/pre-commit-terraform run -a`
<!-- END_AUTOMATED_TF_DOCS_BLOCK -->
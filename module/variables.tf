variable "container_name" {
  type        = string
  description = "Name of the container"
  #validation {
  #  condition     = can(regex("^[a-z]((?!-)[a-z-]){1,61}[a-z]$", var.container_name))
  #  error_message = "Invalid input for container name. Must be between 3 and 63 characters, start and end with a letter, and contain only lowercase letters and hyphens."
  #}
}

variable "storage_account_name" {
  type        = string
  description = "Name of the parent storage account"
}

variable "container_access_type" {
  description = "The Access Level configured for this Container. Possible values are blob, container or private."
  type        = string
  default     = "private"
  validation {
    condition     = contains(["blob", "container", "private"], var.container_access_type)
    error_message = "Invalid value for container access type, possible values are blob, container or private"
  }
}

variable "metadata" {
  description = "A mapping of MetaData for this Container. All metadata keys should be lowercase."
  type        = map(string)
  default     = {}
}
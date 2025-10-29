variable "instance_number" {
  description = "Instance number for resource naming (1-999)"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_number > 0 && var.instance_number < 1000
    error_message = "Instance number must be between 1 and 999."
  }
}

variable "artifacts_location" {
  description = "The base URI where artifacts required by this template are located including a trailing '/'"
  default     = "https://raw.githubusercontent.com/crgarcia12/azure-migrate-env/main/"
}

# variable "_artifactsLocationSasToken" {
#   description = "The sasToken required to access _artifactsLocation. When the template is deployed using the accompanying scripts, a sasToken will be automatically generated. Use the defaultValue if the staging location is not secured."
#   default     = ""
# }

variable "location" {
  description = "Location for all resources."
  default     = "swedencentral"
}

variable "hostvmsize" {
  description = "Size of the Host Virtual Machine"
  default     = "Standard_E32as_v5"
  validation {
    condition     = contains(["Standard_E32as_v5"], var.hostvmsize)
    error_message = "Invalid VM size selected"
  }
}

variable "vmpassword" {
  type      = string
  sensitive = true
}
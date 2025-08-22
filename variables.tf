variable "location" {
  description = "Azure region for the lab (e.g., eastus)"
  type        = string
  default     = "eastus"
}

variable "rg_name" {
  description = "Resource group name"
  type        = string
  default     = "AI-Playground"
}

variable "lab_name" {
  description = "DevTest Lab name"
  type        = string
  default     = "GenAIOps-DevLab"
}

variable "developers" {
  description = "Map of developer VMs to create"
  type = map(object({
    size     = string
    username = string
  }))
  default = {
    chris = { size = "Standard_D4s_v5", username = "chris" }
    fidel = { size = "Standard_D4s_v5", username = "fidel" }
    kevin = { size = "Standard_D4s_v5", username = "kevin" }
    miles = { size = "Standard_D4s_v5", username = "miles" }

  }
}

variable "passwords" {
  description = "Map of VM passwords keyed by developer name"
  type        = map(string)
  sensitive   = true
  # No default on purpose; supply via tfvars or environment
}

variable "allowed_sizes" {
  type        = list(string)
  default     = ["Standard_D2s_v5", "Standard_D4s_v5", "Standard_D8s_v5"]
}

variable "vms_per_user" {
  type    = number
  default = 2
}

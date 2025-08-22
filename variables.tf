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
    password = string
  }))
  default = {
    alice = { size = "Standard_D4s_v5", username = "chris", password = "W3lcome!" }
    bob   = { size = "Standard_D4s_v5", username = "bob",   password = "W3lcome!" }
  }
}

variable "allowed_sizes" {
  type        = list(string)
  default     = ["Standard_D2s_v5", "Standard_D4s_v5", "Standard_D8s_v5"]
}

variable "vms_per_user" {
  type    = number
  default = 2
}

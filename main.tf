resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_dev_test_lab" "lab" {
  name                = var.lab_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    Project = "GenAIOps"
  }
}

resource "azurerm_dev_test_virtual_network" "labvnet" {
  name                = "dtl-vnet"
  lab_name            = azurerm_dev_test_lab.lab.name
  resource_group_name = azurerm_resource_group.rg.name

  subnet {
    use_in_virtual_machine_creation = "Allow"
    use_public_ip_address           = "Allow"
  }
}

resource "azurerm_dev_test_schedule" "shutdown" {
  name                = "LabVmsShutdown"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  lab_name            = azurerm_dev_test_lab.lab.name

  status       = "Enabled"
  task_type    = "LabVmsShutdownTask"
  time_zone_id = "Eastern Standard Time"

  daily_recurrence {
    time = "0200"
  }

  notification_settings {
    status           = "Disabled"
    time_in_minutes  = 30
    webhook_url      = null
  }
}

resource "azurerm_dev_test_policy" "vm_size_policy" {
  name                = "LabVmSize"
  policy_set_name     = "default"
  lab_name            = azurerm_dev_test_lab.lab.name
  resource_group_name = azurerm_resource_group.rg.name

  description   = "Allow only selected VM sizes"
  evaluator_type = "AllowedValuesPolicy"
  threshold     = jsonencode(var.allowed_sizes)
}

resource "azurerm_dev_test_policy" "user_vm_count" {
  name                = "UserOwnedLabVmCount"
  policy_set_name     = "default"
  lab_name            = azurerm_dev_test_lab.lab.name
  resource_group_name = azurerm_resource_group.rg.name

  description    = "Limit per-user VMs"
  evaluator_type = "MaxValuePolicy"
  threshold      = tostring(var.vms_per_user)
}

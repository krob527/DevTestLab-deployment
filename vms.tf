locals {
  gallery = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-23h2-ent"
    version   = "latest"
  }
}

resource "azurerm_dev_test_windows_virtual_machine" "devvm" {
  for_each            = var.developers

  name                = substr(each.key, 0, 15)
  resource_group_name = azurerm_resource_group.rg.name
  lab_name            = azurerm_dev_test_lab.lab.name
  location            = azurerm_resource_group.rg.location

  size                = each.value.size
  username            = each.value.username
  password            = each.value.password

  lab_virtual_network_id = azurerm_dev_test_virtual_network.labvnet.id
  lab_subnet_name        = azurerm_dev_test_virtual_network.labvnet.subnet[0].name

  storage_type = "Premium"

  gallery_image_reference {
    publisher = local.gallery.publisher
    offer     = local.gallery.offer
    sku       = local.gallery.sku
    version   = local.gallery.version
  }

  tags = {
    Owner = each.key
    Role  = "GenAI-Dev"
  }
}

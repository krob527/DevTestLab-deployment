resource "null_resource" "apply_artifacts" {
  for_each = var.developers

  triggers = {
    vm_id = azurerm_dev_test_windows_virtual_machine.devvm[each.key].id
  }

  provisioner "local-exec" {
    working_dir = path.module
    command = <<-EOT
      echo "Waiting for VM ${azurerm_dev_test_windows_virtual_machine.devvm[each.key].name} to be ready for artifacts..."
      timeout 600 powershell -Command "
        do {
          Start-Sleep 30
          Write-Host 'Checking if VM is ready for artifacts...'
          $result = az lab vm apply-artifacts --resource-group ${azurerm_resource_group.rg.name} --lab-name ${azurerm_dev_test_lab.lab.name} --name ${azurerm_dev_test_windows_virtual_machine.devvm[each.key].name} --artifacts .\\artifacts\\artifacts.json 2>&1
          if ($result -notmatch 'ApplyArtifactsUnavailable') {
            Write-Host 'Artifacts applied successfully or different error encountered'
            break
          }
          Write-Host 'VM not ready yet, waiting...'
        } while ($true)
      "
    EOT
  }

  depends_on = [azurerm_dev_test_windows_virtual_machine.devvm]
}

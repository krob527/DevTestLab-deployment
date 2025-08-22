# Azure DevTest Lab Deployment Automation

This repository contains Terraform automation to deploy an Azure DevTest Lab environment with one Windows VM per user, pre-installed with common developer tools via DevTest Lab artifacts.

## Features
- Creates a DevTest Lab, VNet, and policies (auto-shutdown, allowed VM sizes, per-user VM limits)
- Deploys a Windows VM for each user defined in `variables.tf`
- Applies artifacts to install tools like VS Code, Azure CLI, GitHub CLI, Postman, Storage Explorer, Node.js, Python, and more
- Supports custom artifact scripts for additional tooling
- Enables Entra ID (Azure AD) login for all VMs and grants access to the `AIDevs` Entra group

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) >= 1.6.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (with `devtest-labs` extension)
- Sufficient Azure permissions to create resource groups, DevTest Labs, and VMs

## Setup & Usage

1. **Clone this repository**

   ```powershell
   git clone <this-repo-url>
   cd DevTestLab-deployment
   ```

2. **Login to Azure and select your subscription**

   ```powershell
   az login
   az account set --subscription "<SUBSCRIPTION_ID>"
   az extension add -n devtest-labs
   ```

3. **Edit `variables.tf` as needed**
   - Update the `developers` map to add/remove users and set VM sizes, usernames, and passwords.
   - Adjust other variables (location, allowed VM sizes, etc.) as needed.

4. **Initialize Terraform**

   ```powershell
   terraform init
   ```

5. **Plan the deployment**

   ```powershell
   terraform plan -out tfplan
   ```

6. **Apply the deployment**

   ```powershell
   terraform apply tfplan
   ```


7. **Artifacts and Entra ID login will be applied automatically to each VM after creation.**
   - Artifacts are defined in `artifacts/artifacts.json` and `artifacts/install-devtools.ps1`.
   - Azure AD login is enabled for all VMs using a public artifact and PowerShell script.
   - You can customize these files to add or change installed tools.

8. **Grant Entra ID group access to VMs**
   - After deployment, run the provided script to assign the `Virtual Machine User Login` role to the `AIDevs` Entra group:

     ```powershell
     .\assign-entra-role.ps1 <subscription-id> <resource-group-name>
     ```
   - This allows all members of the `AIDevs` group to log in to the VMs using their Entra credentials via RDP.

## Custom Images
- For faster provisioning, you can create a custom image from a configured VM and update the VM resource in `vms.tf` to use your custom image.

## Entra ID (Azure AD) Login for VMs
- Entra ID login is enabled automatically for all Windows VMs using an artifact.
- The `AIDevs` Entra group is granted login rights by running the `assign-entra-role.ps1` script after deployment.
- Users in the `AIDevs` group can log in to the VMs using their Entra credentials via RDP.

## Cleanup
To destroy all resources created by this automation:

```powershell
terraform destroy
```

## References
- [Azure DevTest Labs Terraform Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_lab)
- [DevTest Labs Artifacts](https://github.com/Azure/azure-devtestlab)
- [Microsoft Docs: DevTest Labs](https://learn.microsoft.com/en-us/azure/devtest-labs/)

---

For questions or issues, please contact your DevOps administrator or open an issue in this repository.

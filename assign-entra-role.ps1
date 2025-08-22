# Assign the "Virtual Machine User Login" role to an Entra ID group at the resource group level
# Usage: .\assign-entra-role.ps1 -SubscriptionId <subscription-id> -ResourceGroupName <resource-group-name> -GroupName <group-name>

param(
    [Parameter(Mandatory=$true)][string]$SubscriptionId,
    [Parameter(Mandatory=$true)][string]$ResourceGroupName,
    [Parameter(Mandatory=$false)][string]$GroupName = "AIDevs"
)
$roleName = "Virtual Machine User Login"

# Get the object ID of the Entra ID group
Write-Host "Looking for Entra ID group: $GroupName"
$group = az ad group show --group $GroupName --query id -o tsv 2>$null
if (-not $group) {
    Write-Host "Could not find Entra ID group: $GroupName" -ForegroundColor Red
    Write-Host "Available groups:" -ForegroundColor Yellow
    az ad group list --query "[].{displayName:displayName, id:id}" --output table
    exit 1
}

# Assign the role at the resource group scope
$roleAssignment = az role assignment create `
    --assignee $group `
    --role $roleName `
    --scope "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName"

if ($roleAssignment) {
    Write-Host "Role assignment successful. AIDevs can now log in to VMs via Entra ID."
} else {
    Write-Error "Role assignment failed."
}

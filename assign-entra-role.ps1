# Assign the "Virtual Machine User Login" role to the AIDevs Entra ID group at the resource group level
# Usage: .\assign-entra-role.ps1 <subscription-id> <resource-group-name>

param(
    [Parameter(Mandatory=$true)][string]$SubscriptionId,
    [Parameter(Mandatory=$true)][string]$ResourceGroupName
)

$groupName = "AIDevs"
$roleName = "Virtual Machine User Login"

# Get the object ID of the Entra ID group
$group = az ad group show --group $groupName --query objectId -o tsv
if (-not $group) {
    Write-Error "Could not find Entra ID group: $groupName"
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

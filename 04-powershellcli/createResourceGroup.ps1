$ResourceGroupName = "rg-dev-eus"
$Location = "eastus"

# Create a resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

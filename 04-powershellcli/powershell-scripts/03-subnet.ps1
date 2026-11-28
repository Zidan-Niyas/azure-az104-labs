$ResourceGroupName = "rg-dev-eus"
$VNetName = "vnet-dev-eus-01"
$TestSubnetName = "snet-dev-eus-test-01"

# Get the virtual network
$VNet = Get-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName

# Add the subnet to the virtual network locally
Add-AzVirtualNetworkSubnetConfig -Name $TestSubnetName -AddressPrefix "10.0.3.0/24" -VirtualNetwork $VNet 

# Update the virtual network with the new subnet
$VNet | Set-AzVirtualNetwork
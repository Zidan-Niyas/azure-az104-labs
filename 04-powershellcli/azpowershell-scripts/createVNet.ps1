$ResourceGroupName = "rg-dev-eus"
$Location = "eastus"
$VNetName = "vnet-dev-eus-01"
$WebSubnetName = "snet-dev-eus-web-01"
$DBSubnetName = "snet-dev-eus-db-01"

$webSubnet = New-AzVirtualNetworkSubnetConfig -Name $WebSubnetName -AddressPrefix "10.0.1.0/24"
$dbSubnet  = New-AzVirtualNetworkSubnetConfig -Name $DBSubnetName -AddressPrefix "10.0.2.0/24"
New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $ResourceGroupName -Location $Location -AddressPrefix "10.0.0.0/16" -Subnet $webSubnet,$dbSubnet

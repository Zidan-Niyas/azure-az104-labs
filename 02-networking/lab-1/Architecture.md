# Two-Tier Architecture

## Architecture
- Subscription: Personal Lab
- Region: East US 2
- Resource Group: rg-dev-eus2
- 1 virtual network (vnet-dev-eus2-01)
- 2 subnets:
    - web subnet (snet-dev-eus2-web-01)
    - db subnet (snet-dev-eus2-db-01)
- 2 Virtual Machines
    - web-01 (in web subnet, with public IP)
    - db-01 (in db subnet, no public IP)
- 1 shared Network Security Group (nsg-dev-eus2-shared)
- 2 Application Security Groups
    - web ASG (asg-dev-eus2-web)
    - db ASG (db-dev-eus2-db)

# Setup
- Two VMs: 1 web-VM &  1 db-VM
- web-01 has a public IP and is accessible from the internet via HTTP
- db-01 has no public IP and is blocked from the public internet
- All outbound traffic from both VMs to the internet is blocked, also all inbound traffic from the port range 70-10000 is blocked in both VMs (aside from ports 80[HTTP] and 3306[MySQL], which are given higher priority in the NSG)
- web-01 has an nginx server and mysql client
- db-01 has a mysql-server that is listening on the private-ip of the db-vm
- the mysql server in db-01 is only accessible from web-01
- both VMs use a shared Network Security Group
- each VM has an Application Security Group attached to it
- the ASG is used in the shared-NSG rules instead of the private IP of the VMs
## New Concepts Learned

1. A VM with no public ip will have no outbound access, so it will need a NAT Gateway in its subnet for outbound access
    - Context: The 'db-vm' in the subnet 'snet-dev-eus2-db-01' was created without an attached public ip (db's are normally setup in a way not accessible via the public internet)
    - Problem: When i tried to do 'sudo apt update' from the serial console of the db vm, the packages were not getting installed, because outbound traffic was blocked/notpossible
    - The reason for this: if a vm has no public ip, the packets that leave the vm can't route through the internet only using the vm's private IP, there needs to be something in the middle that converts the private IP to a public IP so that we are able to talk to the internet, that's where the NAT (network address translator) gateway comes in.
    - Solution: create a NAT Gateway in the same resource group and vnet as the db vm and add this NAT gateway to the db vm's subnet 'snet-dev-eus2-db-01'

2. Network Security Groups (two-tier setup for webserver and dbserver)
    - web-vm allows http connections from the internet [inbound - allow]
    - db-vm allows requests to the mysql service on its machine(port 3306) from the web-vm [inbound - allow]
    - web-vm & db-vm denies any requests to the port range 70-10000 on its machine [inbound - deny]
    - web-vm & db-vm denies all outbound traffic to the internet from its machine [outbound -deny]

    So now, the web-vm is open to the internet while the db-vm is blocked from being accessed from the internet. The db-vm can be accessed only from the webserver.

3. Shared NSG for both the web and db servers (nsg-dev-eus2-shared)
    - NSGs are attached to the network interface or the subnet
    - Instead of separate NSGs attached to the network interfaces of each individual VM, we can setup a shared NSG for a Vnet that is attached to the required subnets
    - So now, we will have a central NSG that can be updated on any of the rules that is needed for the VMs and then this NSG is attached to the web and db subnets   

4. NSG attached to subnet vs network interface
    - If the shared-NSG is attached to the web subnet and the web-vm-nsg is attached to the web-vm network interface, the rules need to match in both layers for it to work.
    - For example: If AllowHttpInternet rule is added to the shared NSG but not present in the web-nsg attached to the network interface, access through http://{web-vm-public-ip} wont work, this is because, first the rule attached in the subnet is checked, then the rule attached to the network interface is checked, as the nsg at the network interface has no rule allowing http traffic, the request wont go through.
    
5. Application Security Group
    - Why use it: It acts as a tag for a VM instead of its private IP. When adding rules in the NSG, instead of giving the private IP of the VM, we can use the associated application security group. This is helpful as private IPs can change(if not static) and we would have to update the NSG rule every time the IP changes.
    - Setup: 
        - 1 ASG for web-vm (asg-dev-eus2-web)
        - 1 ASG for db-vm (asg-dev-eus2-db)
        - Add each ASG to their respective VMs
        - Update shared-NSG to use these ASGs instead of the private IPs of the VMs

6. ASG Limitation
    - If we add an ASG to a VM's network interface in a Vnet, we can only add the ASG to other VMs that are part of the same Vnet
    - If we have 2 VMs in the same region but different Vnets, the same ASG can't be attached to both of these VM's network interfaces at the sane time
    - The restriction is due to the NIC (Network INterface Card) of the VM. An Application Security Group attaches to the NIC (technically its IP configuration). So a VM with multiple NICs in different Vnets would also hit the same issue.

7. Virtual Network Peering
    - Used for connecting two virtual networks via the microsoft backbone network
    - If we have two Vnets in the same region, by default the VMs inside each Vnet can't communicate with each other. 
    - Once we add a peering link between the two Vnets, the communication between the two VMs in the two separate VNets becomes possible via the microsoft backbone network

8. Azure Bastion
    - It allows us to connect to machines using just its private IP, the azure bastion host itself will be assigned a public IP
    - Normally if we wanted to access an internal server (eg: db-server), we would setup a jump-server that is accessible from the public network and then connect to the internal server via the jump server, but in this case we would have to manage the jump-server ourselves, patch it, update it etc.
    - Azure Bastion is a fully managed PaaS, you dont expose ports 22(ssh) or 3389(RDP), and securely connect using TLS(port 443) via the azure portal.
    - Azure bastion requires a dedicated subnet (AzureBastionSubnet - the name needs to be exactly this) with a minimum size of /26, and is deployed per Vnet, but can reach VMs in peered VNets.
    - What creating a Bastion does:- It sets up a number of instances that will be used to connect to our VMs securely via the Azure portal
    - Usecase: If we have a fleet of machines that we have to perform administration on, we don't need to attach public IPs to each machine, we can just setup an Azure Bastion in the VNet of those machines and connect using their private IPs (also VMs in peered VNets will be accessible)

9. Network Watcher
    - Used for various network troubleshooting, monitoring and alerting
    - Its features include:
        - Connection Troubleshooting: running a diagnostic test of whether connection is possible between two VMs
        - Connection Monitor: monitor specific connection test cases between a source and destination (eg: http connection between two VMs, frequency=every 30 seconds, sucess threshold=10% checks failed (ie; if 10% checks fail, it will report as failure))
        - IP flow verify: verify if packets can flow inbound or outbound to a particular port in a VM from the port of a remote VM
        - NSG Diagnostics: to test network security group rules actually work or not
        - Next hop: find the intermediate route between a source and destination 
        - Flow logs: stores all connection flow details to a specified vnet/snet/vm in a storage account

10. User Defined Routes
    - By default, all resources (eg: VMs) have open routes between each other, ie; all VMs inside a VNet is able to connect with each other, this is due to the "AllowVnetInbound" security rule.
    - UDR is used to route the traffic the way you want, for eg:- diverting traffic from a web-vm to a db-vm via intermediate firewall vm
    - UDR takes priority over system routes
    - Setup: add route table and then add the route with destination ip as the vnet ip/cidr and next_hop as the intermediate vm from which you want to route the traffic inside the vnet.
    - Eg:- For a 3 VM setup (source, target & central) in a single VNet but 3 different subnets, add a route table and inside this a route giving destination IP as the vnet ip range (172.16.0.0/16) and the next-hop as the ip of the central vm. Therefore, all traffic inside the Vnet like connection between the source and target goes through the central vm. (one thing to keep in mind - need to enable port forwarding in the central vm for this to work)

11. Inbound NAT Rule (Load Balancers)
    - Consider you have a load balancer setup with 2 web VMs sitting in its backend pool (the VMs dont have a public IP)
    - If an administrator wanted to ssh into this backend server, the two options we have is: Azure Bastion or Inbound NAT rule
    - The inbound port rule allows us to connect via the frontend IP address of the load balancer in a particular port that we define (eg: 50000) to the ssh port (22) of the backend web VM.
    - Basically port mapping of the load balancer's port 50000 to the backend server's port 22
    - ie; Admin ---> ssh into loadbalancer-ip (port 50000) ---> routes to port 22 of the backend server ---> ssh into backend server successfull!!

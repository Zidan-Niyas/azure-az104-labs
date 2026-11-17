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
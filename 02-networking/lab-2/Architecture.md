# User-Defined Routes

1. 1 VNet
2. 3 Subnets
    - snet-central-01
    - snet-source-01
    - snet-target-01
3. 3 VMs
    - vm-central-01
    - vm-source-01
    - vm-target-01
4. 1 shared NSG for all 3 subnets
5. Route table 
    - 1 route set for routing all traffic inside the VNet into vm-central-01


## Working
- Setup: 1 vnet with 3 subnets, each with 1 vm
- Goal: route traffic from the source-vm to the target-vm via the central-vm
- The target-vm is an nginx server
- By default when we curl the ip address of the target-vm from the source-vm, we get the nginx html page
- But, once we set a route table and route for routing all traffic in the vnet to the central-vm, this connection between the source and target is cut, curl returns nothing
- For fixing this, we add port forwarding to the network interface of the central-vm and run this command in the serial console of the central-vm: "sudo sysctl -w net.ipv4.ip_forward=1"
- After this route and port-forwarding setup, the curl command from the source-vm successfully routes via the central-vm to the nginx page in the target-vm
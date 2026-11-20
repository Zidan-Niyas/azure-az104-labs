# Load Balancer

1. 1 Vnet
2. 1 Subnet
3. 2 VMs
    - web-01 (no public IP) - nginx server with a static html
    - web-02 (no public IP) - nginx server with a static html
4. 1 shared network security group 
    - Add inbound rule to allow http traffic from the internet to the vnet over http 
5. 1 Load Balancer
    - Frontend IP Config with public IP
    - Backend pool with the two web VMs
    - Health Probe checking HTTP connectivity from the LB to the web VMs
    - Load Balancer rule to forward traffic coming into port 80 from the internet to the backend port 80 


# Working
- The two web VMs dont have a public IP
- Both VMs has an nginx server and a static html page (index.html) at /var/www/html
- The load balancer has a public IP and the two web VMs have been added to the backend pool of the load balancer
- The load balancer rule defines all requests coming in from the internet via http to the public IP of the load balancer be routed to the backend port 80, ie; the web VMs
- Therefore we get the static html page of the web VMs when we try http://{load-balancer-public-ip} 
- A health probe checks connections to port 80 from the load balancer to the backend servers (web-VMs) ensuring they are up
- Point to keep in mind: Although this setup should work as it is, it wont work unless we define an AllowHttp inbound rule to the shared NSG attached to the network interface of both the web VMs. The rule should allow inbound traffic from the internet to the VMs via HTTP (port 80) so that the load balancer's public IP is able to connect to port 80 of the web VMs
# Private DNS System (Self-Managed Domain Controller machine)

1. 1 VNet
2. 3 Subnets
3. 3 Windows VMs (all with public IPs)
    1. Domain Controller VM (vm-dev-eus-dc-01)
        - Active Directory Domain service
        - DNS server
    2. Web server VM (vm-dev-eus-web-01)
        - Internet Installation Service
        - Sample HTML file
    3. Database VM (vm-dev-eus-db-01)


## Setup & Working
1. Install IIS(Internet Installation Service) on the web server, then checking http://{web-server-ip} from the db server will give the default IIS webpage
2. Install "Active Directory Domain Service" in the domain-controller server, then set this server as a domain controller from inside the VM's server manager (add the required domain name in this step)
3. In the Azure Console Vnet resource, change the DNS server from default to the domain controller VM (dc-01), so now all VMs inside this VNet will use this domain-controller VM as its DNS server
4. Restart the web and db VMs
5. In the web and db VMs, modify the WORKGROUP in the server manager --> local server --> WORKGROUP, give the domain name that has been set in the domain controller (eg:- cloudhub4u.com), this adds these VMs to be part of the cloudhub4u.com domain
6. In the domain controller --> Tools --> DNS --> Forward Lookup Zones --> cloudhub4u.com --> Add new host (A record), then leave name as cloudhub4u.com and give the private IP of the web VM, now when we check http://cloudhub4u.com from the db-VM, we will get the IIS page from the web server VM.
7. Therefore, we have successfully setup a private DNS server and domain name for the web-VM that can be accessed from the VMs in the same VNet.



# Private DNS Zone (Azure managed Domain Controller)

1. Use WORKGROUP instead of the domain name in both VMs (server manager --> local server --> domain --> chainge to WORKGROUP)
2. In Vnet, change from custom DNS to default azure-provided DNS service
3. Create a Private DNS Zone "cloudhub4u.com" and add the VNet as the network link with auto registration turned on (this automatically adds the DNS records for the VMs in the VNet)
4. So now, this private DNS zone acts as the DNS service for the VMs in this VNet

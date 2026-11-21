# Load Balanced Virtual Machine Scale Set

1. 1 VMSS: 2 instances
2. 1 Load balancer with a public IP


## Working
- The VMSS instances have an nginx webserver and a index.hml page setup but no public IP
- The load-balancer is setup in such a way that, all HTTP traffic (port 80) to the public IP of the load balancer routes to port 80 of the backend servers (VMSS instances)
- So, we get the html pages from the scale set via the load balancer
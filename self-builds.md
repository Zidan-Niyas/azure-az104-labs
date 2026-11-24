# exam-shaped builds by domain:

1. Identity and governance: a management group hierarchy with a Policy assignment (a deny policy, plus a tag-inheritance modify policy), a custom RBAC role, a resource lock, and RBAC at different scopes. Test what each one actually blocks. Also try a dynamic group and a guest user.

2. Networking: hub-spoke with peering and a VM in each spoke, NSG and ASG rules (then check effective rules and effective routes), a UDR, a private endpoint to a storage account with a private DNS zone, and a Load Balancer vs Application Gateway setup. Read about VPN Gateway and ExpressRoute instead of building them, because they're slow and costly.

3. Storage: the scenarios from the questions above: a SAS with a stored policy, a firewall with a service endpoint vs a private endpoint, a lifecycle policy, object replication, mounting an Azure file share, and File Sync on a VM.

4. Compute: deploy a VM from an ARM or Bicep template and change its parameters, a VMSS with an autoscale rule, an App Service with deployment slots, ACI or Container Apps, a VM backup and restore, and a disk resize.

5. Monitor and maintain: a Log Analytics workspace with diagnostic settings, a few KQL queries, an alert with an action group, and a Backup vault restore.
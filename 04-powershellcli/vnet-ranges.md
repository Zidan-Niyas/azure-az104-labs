# VNet Ranges

- Azure doesn't enforce it, but VNets should use private (RFC 1918) ranges:
    - 10.0.0.0/8
    - 172.16.0.0/12
    - 192.168.0.0/16
- These are pools. Each VNet gets a smaller non-overlapping slice, e.g. 10.0.0.0/16, 10.10.0.0/16, 10.20.0.0/16
- Don't use a huge range like /8 for one VNet, it uses up the whole pool
- Fallback pool: 100.64.0.0/10 (RFC 6598), treated as private in Azure
- Public ranges I don't own (e.g. 11.0.0.0/16, 172.0.0.0/16): Azure routes traffic for those IPs inside the VNet, so the real servers become unreachable from it. (Eg: if a VM inside a VNet with the address prefix 11.0.0.0/16 which is a public ip range tries to connect to a public server at 11.0.0.5, it wont be able to as this ip has been claimed by the VM. So the actual public server at this range will be unreachable by servers inside the VNet)
- VNets must not overlap each other or on-prem, or peering/VPN breaks
- Azure reserves 5 IPs per subnet; smallest subnet is /29
- Keep a written list of which range went to which VNet
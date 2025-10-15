# VMware Networking Plan

| Network | VMware vSwitch | Subnet          | Purpose                              |
|---------|----------------|-----------------|--------------------------------------|
| VMnet8  | NAT            | Provided by host| WAN uplink for pfSense               |
| VMnet2  | Host-only      | 10.10.0.0/24    | Internal LAN (DC1, SEC-UB1, WIN11)   |
| VMnet9  | Host-only      | 10.20.0.0/24    | DMZ (HP-UB1 honeypots)               |

## Steps

1. In VMware Workstation, open **Edit > Virtual Network Editor**.
2. Configure **VMnet8** as NAT; allow DHCP but disable for lab VMs (pfSense provides WAN interface via DHCP).
3. Set **VMnet2** to Host-only, disable VMware DHCP, and assign subnet `10.10.0.0/24`. (Already present on host as `192.168.63.1`; update to 10.10.0.0/24.)
4. Repurpose **VMnet9** (currently `192.168.64.1`) as DMZ host-only network. Disable VMware DHCP and set subnet `10.20.0.0/24`.
   - If you prefer to keep VMnet9 unchanged, create a new **VMnet3** host-only network with the DMZ subnet instead. Update pfSense mapping accordingly.
5. Map pfSense interfaces:
   - `wan` -> VMnet8
   - `lan` -> VMnet2 (10.10.0.1/24)
   - `opt1` (DMZ) -> VMnet9 (10.20.0.1/24)
6. Connect lab VMs to appropriate networks:
   - DC1, SEC-UB1, WIN11 -> VMnet2
   - HP-UB1 -> VMnet3

## Validation Checklist

- pfSense obtains WAN address via DHCP on VMnet8.
- LAN hosts receive 10.10.0.x from DC1 (after DHCP configured).
- DMZ host receives 10.20.0.x from pfSense DHCP or static assignment (from VMnet9/DMZ network).
- DMZ cannot reach the Internet except for allowed DNS/SIEM ports.

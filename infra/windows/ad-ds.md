# Active Directory DS (DC1)

## Host Details

- OS: Windows Server 2022 Standard
- Hostname: `DC1`
- Domain: `lab.local`
- Roles: AD DS, DNS, DHCP

## Build Steps

1. Install prerequisites:
   - Assign static IP `10.10.0.10`.
   - Set preferred DNS to `127.0.0.1`.
2. Add roles via PowerShell:

   ```powershell
   Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
   ```
3. Promote to domain controller:

   ```powershell
   Install-ADDSForest -DomainName "lab.local" -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force)
   ```

   Reboot when prompted.
4. Configure DHCP scope:
   - Scope: `10.10.0.100` - `10.10.0.200`
   - Gateway: `10.10.0.1` (pfSense LAN)
   - DNS server: `10.10.0.10`
5. Create service accounts and groups for lab operations (`svc_wazuh`, `honeypot_admins`).

## Validation

- `dcdiag /v` returns success.
- Clients receive DHCP leases and can resolve internal hosts.
- Time synchronization points to pfSense or external NTP.

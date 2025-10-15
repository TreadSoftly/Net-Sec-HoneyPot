# NAT Port Forwards

| External Port | Protocol | Internal Host | Internal Port | Service        | Notes                         |
|---------------|----------|---------------|---------------|----------------|-------------------------------|
| 22            | TCP      | HP-UB1        | 2222          | Cowrie SSH     | Map to high port to avoid pfSense SSH |
| 80            | TCP      | HP-UB1        | 80            | DVWA/Dionaea   | Swap target service as needed |
| 21            | TCP      | HP-UB1        | 21            | Dionaea FTP    | Optional exposure             |
| 445           | TCP      | HP-UB1        | 445           | Dionaea SMB    | Heavy scanning expected       |
| 1433          | TCP      | HP-UB1        | 1433          | Dionaea MSSQL  | Monitor for SQL brute force   |
| 3306          | TCP      | HP-UB1        | 3306          | Dionaea MySQL  | Monitor for auth attempts     |

## Configuration Steps

1. Navigate to **Firewall > NAT > Port Forward**.
2. Create rules for each external port with destination `WAN address` and redirect target `HP-UB1`.
3. Check **Add associated filter rule** so traffic is permitted to DMZ host.
4. Save and apply changes; pfSense auto-creates firewall rules on WAN.
5. Test from external host (or `nmap` from another VM using WAN path) to confirm forwarding.

## Logging

- Enable logging on associated firewall rules for evidence gathering.
- Use aliases for port groups (e.g., `DMZ_FORWARD_TCP`) to simplify maintenance.

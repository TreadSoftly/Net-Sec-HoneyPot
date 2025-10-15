# Topology

- **WAN (VMnet8/NAT)** -> Internet access for pfSense
- **LAN 10.10.0.0/24 (VMnet2)** -> DC1, SEC-UB1 (SIEM), WIN11-01
- **DMZ 10.20.0.0/24 (VMnet3)** -> HP-UB1 (Cowrie, Dionaea, DVWA)
- **DMZ egress**: DNS to DC1 and SIEM ports only; deny/alert everything else

## Diagram

See the Mermaid architecture diagram in `README.md`.

## Ports Exposed from WAN (forwarded to DMZ)

- 22/TCP -> Cowrie 2222
- 80/TCP -> DVWA 80 (or Dionaea 80)
- 21/TCP, 445/TCP, 1433/TCP, 3306/TCP -> Dionaea

## Log & Flow Paths

- pfSense -> rsyslog (SEC-UB1) -> SIEM
- Cowrie/Dionaea -> Wazuh agent -> SIEM
- NetFlow/IPFIX -> nfdump (SEC-UB1)

# Safety model

- **Segmentation**: WAN/LAN/DMZ; DMZ -> LAN blocked
- **Egress control**: DMZ can talk only to SIEM (1514/TLS, 514/UDP) and DC1 DNS (53/TCP+UDP)
- **Host isolation**: Host firewall blocks inbound from 10.10.0.0/16 and 10.20.0.0/16
- **Snapshots**: Revert high-interaction VMs after compromise
- **No secrets**: Never commit keys/logs with real IPs; use `scripts/utilities/sanitize-logs.py`
- **Cloud honeytoken**: No IAM policies; any usage alerts via EventBridge -> SNS

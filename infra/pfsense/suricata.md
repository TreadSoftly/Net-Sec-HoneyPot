# Suricata Integration (Optional)

## Deployment Options

- **Inline (IPS) on WAN**: Inspect inbound traffic before it hits honeypots.
- **IDS on DMZ**: Monitor east-west attempts after services are exposed.

## Installation Steps

1. In pfSense, navigate to **System > Package Manager > Available Packages** and install **Suricata**.
2. Assign Suricata to `WAN` (required) and optionally `DMZ`.
3. Enable `Promiscuous Mode` for visibility; keep inline IPS disabled initially to avoid blocking benign research traffic.
4. Download rule sets (ET Open, Suricata-Community) and enable categories relevant to brute force, malware, and C2.
5. Configure logging to send `eve.json` to `SEC-UB1` using syslog or Filebeat.

## Tuning

- Suppress noisy signatures targeting DMZ services (DVWA, Dionaea) after verifying they are benign.
- Map Suricata alerts to Wazuh via custom decoder to correlate with honeypot sessions.
- Consider enabling HTTP and TLS logging modules for richer metadata.

## Maintenance

- Schedule rule updates weekly.
- Review blocked/alerted traffic and add context to runbooks if recurring patterns emerge.

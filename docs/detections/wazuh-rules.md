# Wazuh Rules Overview

## Custom Rule Pack

Path: `detections/wazuh/local_rules.xml`

| Rule ID | Description                     | MITRE ATT&CK             | Notes                                       |
|---------|---------------------------------|--------------------------|---------------------------------------------|
| 100001  | Cowrie SSH session started      | T1021.004 Lateral Movement | Detects new interactive sessions in DMZ     |
| 100010  | DMZ egress blocked by firewall  | T1071 Command & Control  | Triggers when pfSense blocks outbound traffic |

## Deployment Steps

1. Copy `local_rules.xml` to `/var/ossec/etc/rules/local_rules.xml`.
2. Restart Wazuh manager: `systemctl restart wazuh-manager`.
3. Generate test events:
   - Cowrie: SSH to the honeypot (`ssh root@<wan-ip> -p 2222`).
   - pfSense: Attempt outbound connection from DMZ host (should be blocked).

## Decoder Support

If Cowrie logs are ingested as JSON, use `detections/wazuh/decoders/cowrie_decoder.xml` to map field names. Place the decoder in `/var/ossec/etc/decoders/local_decoder.xml`.

## Roadmap Ideas

- Add Suricata alert correlation when IDS is enabled.
- Enrich DMZ egress alerts with GeoIP lookups before forwarding to SOC channels.

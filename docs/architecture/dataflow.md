# Dataflow

## Telemetry Ingestion

| Source                          | Transport                      | Collector             | SIEM / Analytics      |
|---------------------------------|--------------------------------|-----------------------|-----------------------|
| pfSense system + firewall logs  | Syslog UDP/514                 | SEC-UB1 `rsyslog`     | Wazuh indexer         |
| pfSense NetFlow/IPFIX           | UDP/2055                       | SEC-UB1 `nfdump`      | Wazuh / manual pivot  |
| Cowrie, Dionaea honeypots       | Wazuh agent -> TLS/1514         | Wazuh manager         | Wazuh SIEM dashboards |
| Windows Event Logs + Sysmon     | Wazuh agent -> TLS/1514         | Wazuh manager         | Wazuh SIEM dashboards |
| AWS CloudTrail / GuardDuty      | AWS native pipes               | EventBridge -> SNS     | Email notifications   |

## Processing Pipeline

1. **Collection**  
   - pfSense emits syslog to `SEC-UB1` where `rsyslog` stores raw copies and forwards JSON-formatted events into Wazuh.
   - Wazuh agents on Windows, Ubuntu, and honeypots ship events over TLS/1514 to the Wazuh manager.
   - NetFlow hits `nfdump` for retention and enrichment of DMZ traffic volumes.
2. **Normalization & Enrichment**  
   - Custom Wazuh decoders parse Cowrie JSON fields (see `detections/wazuh/decoders/cowrie_decoder.xml`).
   - Local rules add MITRE ATT&CK context and escalate priority for DMZ egress blocks.
3. **Detection**  
   - Wazuh correlation rules raise alerts that trigger runbooks in `docs/runbooks/`.
   - Splunk/Sentinel queries provide alternate analytics when exporting data to those platforms.
4. **Notification**  
   - High-severity alerts can push to email or chat via Wazuh integrations (to be configured).
   - AWS honeytoken activity triggers EventBridge -> SNS email.

## Data Retention

- Wazuh indexer retains hot data for 14 days (tune per storage).
- `nfdump` rotates NetFlow files daily, storing seven days in the lab.
- Evidence for interviews is exported, sanitized (`scripts/utilities/sanitize-logs.py`), and stored under `docs/evidence/`.

## Security Controls

- TLS for agent-to-manager traffic using Wazuh-managed certificates.
- Syslog restricted to pfSense IPs with host-based firewall rules.
- Evidence exports scrub sensitive fields before commit.

# Snapshot Strategy

## Baselines

- **pfSense**: Snapshot after WAN/LAN/DMZ interfaces and firewall rules are configured.
- **SEC-UB1**: Snapshot after Wazuh stack + rsyslog + nfdump are operational.
- **HP-UB1**: Snapshot after honeypots installed but before exposure to Internet.
- **Windows hosts**: Snapshot after domain join, GPO baseline, and Sysmon installed.

## Workflow

1. Take a clean snapshot before exposing services or running adversary simulations.
2. Capture notes in VMware snapshot description (date, configuration changes).
3. After an incident, clone snapshot for evidence, then revert to baseline.
4. Periodically consolidate snapshots to manage disk usage.

## Restore Checklist

- Verify NICs reconnect to the expected VMnet after revert.
- Re-run post-restore checks (Wazuh agent status, pfSense services, DC replication).
- Update documentation if restore revealed configuration drift.

# IR-02 DMZ Egress Blocks

## Trigger

- Wazuh alert `100010` (pfSense DMZ egress blocked) or pfSense syslog entry tagged `block` with source `10.20.0.0/24`.

## Triage (10 min)

1. Confirm source host/service in pfSense logs (NAT rule, interface, port).
2. Pivot to Wazuh host metrics (CPU/mem) and honeypot logs (Cowrie, Dionaea) for the same timestamp.
3. Capture destination IP/domain; look up reputation (VirusTotal, Talos).
4. Determine if traffic was expected (e.g., tuning artifact) or malicious outbound attempt.

## Contain & Eradicate

- If malicious, snapshot the DMZ VM before changes.
- Disable exposed service or user account generating outbound traffic.
- Review firewall rules to ensure deny action remains enforced; adjust logging threshold if noisy.

## Recover & Lessons

- Update honeypot banners or throttling to slow brute-force loops.
- Add detection content (e.g., Splunk/Sentinel queries) for the destination indicators.
- Sanitize and store evidence in `docs/evidence/`.

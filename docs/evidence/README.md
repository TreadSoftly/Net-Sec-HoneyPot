# Evidence Capture Checklist

## Screenshots to Collect

- Wazuh Agents view (all hosts online) with filters for Cowrie and Sysmon events.
- pfSense NAT and DMZ firewall rule table showing egress deny with logging enabled.
- `nfdump` top talkers command output (text export plus screenshot).
- DVWA page accessed via WAN IP and forwarded port.
- AWS GuardDuty and Security Hub dashboards, EventBridge rule, and SNS alert email.
- Control matrix (`docs/governance/control-matrix.md`) rendered in Markdown viewer.
- Runbooks (two examples) demonstrating concise IR steps.

## Sanitization Notes

- Blur or redact public IPs, domain names, email addresses, and AWS account IDs.
- Replace key IDs or token values with `REDACTED`.
- Store sanitized imagery under `docs/evidence/images/`.
- Bundle evidence packs using `scripts/make-evidence-pack.ps1` before sharing.

# Dionaea Honeypot

## Purpose

Dionaea emulates multiple services (FTP, HTTP, SMB, MSSQL, MySQL) to collect malware samples and connection metadata.

## Installation (Ubuntu 22.04)

```bash
sudo apt update
sudo apt install -y dionaea
sudo systemctl enable --now dionaea
```

Packages from Ubuntu repository include systemd service and default config.

## Configuration

- Config file located at `/etc/dionaea/dionaea.conf`.
- Enable desired protocols:
  - FTP (21), HTTP (80), HTTPS (443), SMB (445), MSSQL (1433), MySQL (3306).
- Set `download.enabled = false` initially if you do not want to store samples.
- Configure logging to JSON for Wazuh ingestion (`log-json` section).

## Firewall & NAT

- Use pfSense NAT to expose required ports from WAN to DMZ host.
- Maintain allow rules only for honeypot ports; block all other outbound traffic.

## Telemetry

- Wazuh agent monitors `/var/log/dionaea/*.log`.
- NetFlow captures volume of connections to DMZ.
- Optional: Forward captured binaries (sanitized) to `docs/evidence/`.

## Maintenance

- Rotate logs frequently (high volume).
- Run updates monthly to ensure dependencies are patched.
- Review runbooks to document high-fidelity alerts.

# pfSense Data Collection Checklist

Run these after pfSense is deployed to capture configuration details for documentation and evidence.

## 1. Interface & Routing Snapshot

```bash
ssh admin@10.10.0.1 "ifconfig"
ssh admin@10.10.0.1 "netstat -rn"
```

## 2. Firewall & NAT Rules

```bash
ssh admin@10.10.0.1 "pfctl -sr"
ssh admin@10.10.0.1 "pfctl -sn"
```

## 3. Export Configuration

```bash
ssh admin@10.10.0.1 "cat /cf/conf/config.xml" > pfSense-config.xml
```

> Store the XML securely; redact passwords/keys before sharing or committing. Use `scripts/utilities/sanitize-logs.py` for sensitive strings.

## 4. NetFlow & Syslog Status

```bash
ssh admin@10.10.0.1 "clog -f /var/log/system.log | grep -i syslog"
ssh admin@10.10.0.1 "clog -f /var/log/netflow.log"
```

## 5. Evidence Notes

- Capture screenshots of NAT/Firewall pages (`Firewall > NAT`, `Firewall > Rules`).
- Ensure DMZ deny rules are logging; note the rule number for Wazuh correlation.
- Store sanitized outputs under `docs/evidence/` as references for runbooks and audits.

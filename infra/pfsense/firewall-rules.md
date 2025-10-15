# Firewall Rules

## WAN Rules

1. Auto-generated rules for NAT forwards (22, 80, 21, 445, 1433, 3306).
2. Block all other inbound WAN traffic (default deny).
3. Allow outbound DNS from pfSense to upstream resolver.

## DMZ Interface (OPT1)

| Order | Action | Source          | Destination | Port          | Description                                 |
|-------|--------|-----------------|-------------|---------------|---------------------------------------------|
| 1     | Pass   | 10.20.0.0/24    | SEC-UB1     | 1514/TCP      | Allow Wazuh agent to manager                |
| 2     | Pass   | 10.20.0.0/24    | SEC-UB1     | 514/UDP       | Allow syslog to rsyslog                     |
| 3     | Pass   | 10.20.0.0/24    | DC1         | 53/TCP, UDP   | Allow DNS resolution                        |
| 4     | Block+Log | 10.20.0.0/24 | any         | any           | Deny all other egress (alert rule 100010)   |

## LAN Interface

- Allow LAN to DMZ (stateful) for management.
- Allow LAN to Internet (optional; restrict via proxy if desired).
- Allow LAN to pfSense services (WebGUI, DNS).

## Logging Strategy

- Enable logging on DMZ block rule to feed Wazuh rule `100010`.
- Forward pfSense logs to `SEC-UB1` via `Status > System Logs > Settings`.
- Tag DMZ alerts with `DMZ_EGRESS` in syslog for easier parsing.

# Net-Sec-HoneyPot

**Goal:** Build and safely operate a segmented **honeynet** that mirrors a city-gov SOC + systems-security environment:

- **pfSense** router/firewall with **WAN/LAN/DMZ** segmentation, **syslog** and **NetFlow/IPFIX**
- **Windows Server 2022** (AD DS, DNS, DHCP, GPO, LAPS), **Windows 11** endpoint with **Sysmon**
- **Ubuntu** security box running **Wazuh** (open-source XDR/SIEM), **rsyslog**, **nfdump**
- **DMZ honeypots:** **Cowrie** (SSH/Telnet), **Dionaea** (SMB/FTP/HTTP/DB), optional **DVWA**
- **AWS**: **CloudTrail**, **GuardDuty**, **Security Hub**, and **honeytoken** keys with **EventBridge -> SNS** alerting

> **Why this portfolio?** To show end-to-end capability: design, hardening, detections mapped to **MITRE ATT&CK**, IR **runbooks**, and governance mapping to **NIST CSF / 800-53**.

## Architecture

```mermaid
flowchart LR
  Internet((Internet)) -->|WAN Port Forwards| pfSenseWAN[pfSense (WAN)]
  pfSenseWAN --> pfSenseLAN[pfSense LAN 10.10.0.1]
  pfSenseWAN --> pfSenseDMZ[pfSense DMZ 10.20.0.1]
  subgraph LAN[LAN 10.10.0.0/24]
    DC1[DC1: Win Server 2022\nAD DS/DNS/DHCP]
    SECUB1[SEC-UB1: Ubuntu\nWazuh/rsyslog/nfdump]
    WIN11[WIN11-01: Sysmon + Wazuh agent]
  end
  subgraph DMZ[DMZ 10.20.0.0/24]
    HPUB1[HP-UB1: Cowrie + Dionaea + DVWA]
  end
  pfSenseLAN --- DC1
  pfSenseLAN --- SECUB1
  pfSenseLAN --- WIN11
  pfSenseDMZ --- HPUB1
  HPUB1 -->|TLS/1514 + Syslog/514| SECUB1
  pfSenseDMZ -->|NetFlow/2055| SECUB1
  pfSenseLAN -->|Syslog/514| SECUB1
  subgraph AWS[ AWS Account ]
    CT[CloudTrail]
    GD[GuardDuty]
    SH[Security Hub]
    EB[EventBridge Rule]
    SNS[SNS Email]
  end
  Internet -.->|If honeytoken used| CT -.-> EB -.-> SNS
  GD --> SH
```

## Quick Links

- Architecture: `docs/architecture/topology.md`
- Runbooks: `docs/runbooks/`
- Detections (rules & queries): `detections/`
- Roadmap: `docs/roadmap.md`
- Safety: `docs/architecture/safety.md` and `SECURITY.md`

## Evidence (screenshots)

See `docs/evidence/README.md` for what to capture and how to sanitize.

## Safety & Ethics

Honeypots are isolated in a DMZ with egress controls. Do not use any captured malware outside this lab. See `SECURITY.md` for rules.

## License

MIT (see `LICENSE`).

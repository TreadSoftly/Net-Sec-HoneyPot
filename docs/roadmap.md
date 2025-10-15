# Roadmap

## Milestone 0 - Repo scaffolding

- [x] Commit repo structure, policies, CI (lint + secret scan)
- [x] README + architecture pages

**Done when:** CI passes; README renders diagrams

## Milestone 1 - Base infra

- [ ] VMware networks (VMnet8/2/9), pfSense (WAN/LAN/DMZ)
- [ ] DMZ DHCP; LAN via DC1 later; DMZ -> SIEM/DNS allow; DMZ egress deny

**Done when:** LAN/DMZ hosts get IPs; DMZ cannot reach Internet except DNS/SIEM

## Milestone 2 - SIEM & collectors

- [ ] Wazuh single-node up; rsyslog receiving pfSense; nfdump collecting flows

**Done when:** Dash shows agents online; pfSense logs visible; nfdump queries return flows

## Milestone 3 - Windows domain & telemetry

- [ ] DC1 AD DS/DNS/DHCP; baseline GPO; LAPS
- [ ] WIN11 joined; Sysmon + Wazuh agent

**Done when:** Login events + Sysmon appear in Wazuh

## Milestone 4 - Honeypots (DMZ)

- [ ] Cowrie (2222); Dionaea (21/80/445/1433/3306); DVWA (80)
- [ ] pfSense WAN NAT to each service; Wazuh agent on HP-UB1

**Done when:** External SSH/HTTP/SMB hits generate events

## Milestone 5 - Cloud honeytoken

- [ ] CloudTrail, GuardDuty, Security Hub enabled
- [ ] Honeytoken user + keys (no perms); EventBridge -> SNS alert

**Done when:** Test call triggers email alert

## Milestone 6 - Detections & runbooks

- [ ] Wazuh custom rules (Cowrie session, DMZ egress block)
- [ ] SPL/KQL queries; 3 IR runbooks

**Done when:** Rules fire on test; docs committed

## Milestone 7 - Evidence pack

- [ ] Screenshots (redacted); control matrix complete
- [ ] One-pager + slide deck

**Done when:** `presentations/` populated; evidence zip created

## Milestone 8 - Optional: IDS & Packet Tracer

- [ ] Suricata alert-only on WAN/DMZ
- [ ] Packet Tracer lab: NetFlow/syslog/AAA

## GitHub Labels & Project

- Labels: `area/infra`, `area/honeypots`, `area/siem`, `area/cloud`, `area/detections`, `area/docs`, `good first task`, `blocked`, `help wanted`, `prio/high`, `prio/med`, `prio/low`.
- Project board: Kanban workflow (Backlog -> In Progress -> Review -> Done).
- Create milestones M0-M8 corresponding to sections above.

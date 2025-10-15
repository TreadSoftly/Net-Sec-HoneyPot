# Control Matrix

| Risk                                   | Framework Control       | Technical Control                             | Evidence (path)                      | Owner | Status |
|----------------------------------------|-------------------------|-----------------------------------------------|--------------------------------------|-------|--------|
| RDP brute force                        | NIST 800-53 AC-7        | Wazuh rule on Win 4625/4624; pfSense WAN rules | docs/evidence/images/wazuh_rdp.png   | You   | DONE   |
| DMZ pivot to LAN                       | SC-7, AC-4              | pfSense DMZ->LAN deny; alert on any attempt   | docs/architecture/safety.md          | You   | DONE   |
| Unmonitored admin actions              | AU-12, AU-6             | Sysmon + Windows audit policy                 | infra/windows/gpo-baseline.md        | You   | DONE   |
| Public service abuse (SMB/FTP/HTTP)    | SI-4, RA-5              | Dionaea + alerts; NetFlow baseline            | docs/evidence/images/dionaea.png     | You   | OPEN   |
| Cloud key misuse (honeytoken)          | CA-7, IR-5              | CT+EventBridge+SNS alert                      | docs/evidence/images/aws_alert.png   | You   | OPEN   |

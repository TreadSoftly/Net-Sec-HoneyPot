# Compliance Notes

- **NIST CSF**: Project aligns with Identify (ID.AM), Protect (PR.AC, PR.PT), Detect (DE.CM), Respond (RS.CO), and Recover (RC.RP).
  Emphasis is on documented assets, network segmentation, monitoring, and runbooks.
- **NIST 800-53**: Primary controls implemented include AC-4 (information flow enforcement), AU-12 (audit generation),
  IR-5 (incident monitoring), and SI-4 (system monitoring). The control matrix maps lab evidence to these controls.
- **HIPAA**: Lab is non-production, but security tenets apply. Segmentation and monitoring demonstrate safeguards relevant
  to Section 164.308 (Administrative Safeguards) and Section 164.312 (Technical Safeguards).
- **CJIS**: Emphasizes network isolation, logging, and access control. pfSense configurations and Wazuh audit trails illustrate
  how a CJIS enclave could be monitored.
- **PCI DSS**: Honeypot services are not cardholder systems, yet DMZ hardening and logging mirror Requirement 1 (firewall
  segmentation) and Requirement 10 (logging & monitoring).

> These notes describe how the lab could satisfy or demonstrate understanding of compliance objectives. Always consult
> official assessors for production environments.

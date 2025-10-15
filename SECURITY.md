# Safety, Ethics, and Legal

- Honeypot services run in a **segmented DMZ** with strict **egress deny**. They **must not** be used to attack others.
- Logs, samples, and screenshots are **redacted** before publication. No real credentials or keys are stored in this repo.
- The **AWS honeytoken** IAM user has **no policies**. Any API call will fail but is logged; alerts are for research only.
- This project is for **educational and defensive** purposes. Follow all applicable laws, your ISP’s AUP, and employer policies.

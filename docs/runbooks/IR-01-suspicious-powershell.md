# IR-01 Suspicious PowerShell (Workstation)

## Trigger

- Wazuh alert on Sysmon EID 1 process create where Image endswith "powershell.exe" and CommandLine contains "-enc" or "-nop"

## Triage (10 min)

1. Identify host/user/time and parent process (Sysmon fields)
2. Check Wazuh for related network connections (EID 3) and script block logs
3. If suspicious:
   - Isolate host (EDR or pull NIC)
   - Collect volatile data (process list, TCP connections), preserve event logs

## Contain & Eradicate

- Kill malicious process; remove persistence (Run keys, Scheduled Tasks)
- Reset creds if credential theft suspected

## Recover & Lessons

- Patch/root cause; add detection for exact command-line pattern
- Attach evidence in `docs/evidence/`

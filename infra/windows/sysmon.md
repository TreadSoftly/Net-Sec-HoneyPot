# Sysmon Deployment

## Installation

1. Download Sysmon from Microsoft Sysinternals.
2. Place `Sysmon64.exe` and configuration file (e.g., [SwiftOnSecurity sysmon-config](https://github.com/SwiftOnSecurity/sysmon-config)) in `C:\Temp\Sysmon`.
3. Install using PowerShell or the script `scripts/windows/install_sysmon.ps1`.

Manual command:

```powershell
.\Sysmon64.exe -accepteula -i sysmonconfig-export.xml
```

## Configuration Highlights

- Enable ProcessCreate, NetworkConnect, FileCreate, RegistryEvent, and ImageLoad.
- Include detection filters for PowerShell, LOLBins, and script block logging.
- Configure Sysmon to log to Windows Event Log (`Microsoft-Windows-Sysmon/Operational`).

## Integration with Wazuh

- Wazuh agent ships Sysmon events automatically when the module is enabled.
- Ensure `sysmon` decoder is active and map to MITRE tactics in custom rules.

## Maintenance

- Review configuration quarterly to include new threat techniques.
- Use `sysmon -c` to update config without reinstalling.
- Document changes in `docs/runbooks/` if detection coverage shifts.

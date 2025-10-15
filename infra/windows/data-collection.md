# Windows Data Collection Checklist

Use these commands once the servers/workstations are built to capture configuration details for documentation and evidence. Run in an elevated PowerShell session.

## Domain Controller (DC1)

```powershell
Get-NetIPConfiguration
Get-ADDomain
Get-ADForest
Get-DhcpServerv4Scope
Get-GPOReport -All -ReportType Html -Path C:\Temp\gpo-report.html
```

Copy `C:\Temp\gpo-report.html` to the repo (sanitize first) for inclusion in evidence or appendix docs.

## Windows 11 Workstation (WIN11-01)

```powershell
Get-NetIPConfiguration
Get-WmiObject Win32_ComputerSystem | Select-Object Name, Domain
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 5 | Format-Table TimeCreated, Id, Message -AutoSize
Get-MpComputerStatus | Select-Object AMProductVersion, AntivirusEnabled, RealTimeProtectionEnabled
```

## Sysmon & Wazuh Agent Status

```powershell
Get-Service -Name Sysmon64, WazuhSvc
Get-Content "C:\Program Files (x86)\ossec-agent\ossec.log" -Tail 20
```

## Evidence Handling

- Mask hostnames or IPs where required using `scripts/utilities/sanitize-logs.py`.
- Store raw outputs under `docs/evidence/` along with screenshots of GPO settings and Sysmon dashboards.

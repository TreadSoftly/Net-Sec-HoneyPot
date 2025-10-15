#requires -RunAsAdministrator

<#
.SYNOPSIS
    Installs and enrolls Wazuh agent on Windows hosts.

.PARAMETER ManagerAddress
    FQDN or IP of the Wazuh manager (default: sec-ub1.lab.local).

.PARAMETER AgentName
    Custom agent name. Defaults to computer name.

.PARAMETER EnrollmentPassword
    Enrollment password configured on the Wazuh manager.
#>

param(
    [string]$ManagerAddress = "sec-ub1.lab.local",
    [string]$AgentName = $env:COMPUTERNAME,
    [Parameter(Mandatory = $true)]
    [string]$EnrollmentPassword
)

$ErrorActionPreference = "Stop"
$agentUrl = "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.7.0-1.msi"
$downloadPath = "$env:TEMP\wazuh-agent.msi"

Write-Host "Downloading Wazuh agent..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $agentUrl -OutFile $downloadPath

Write-Host "Installing Wazuh agent..." -ForegroundColor Cyan
Start-Process msiexec.exe -ArgumentList "/i `"$downloadPath`" /qn /norestart" -Wait

Write-Host "Configuring ossec.conf..." -ForegroundColor Cyan
$configPath = "C:\Program Files (x86)\ossec-agent\ossec.conf"
if (-not (Test-Path $configPath)) {
    throw "ossec.conf not found. Installation may have failed."
}

$xml = [xml](Get-Content $configPath)
$serverNode = $xml.ossec_config.client.server
$serverNode.address = $ManagerAddress
$serverNode.port = "1514"
$xml.ossec_config.client['name'] = $AgentName
$xml.Save($configPath)

Write-Host "Enrolling agent..." -ForegroundColor Cyan
& "C:\Program Files (x86)\ossec-agent\agent-auth.exe" -m $ManagerAddress -P $EnrollmentPassword -A $AgentName

Start-Service WazuhSvc

Write-Host "Wazuh agent installation complete."


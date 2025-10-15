#requires -RunAsAdministrator

<#
.SYNOPSIS
    Installs Sysmon with a hardened configuration on Windows hosts.

.PARAMETER ConfigUrl
    Public URL to a Sysmon configuration XML. Defaults to SwiftOnSecurity config.

.PARAMETER InstallPath
    Directory to download Sysmon binaries.
#>

param(
    [string]$ConfigUrl = "https://raw.githubusercontent.com/SwiftOnSecurity/sysmon-config/master/sysmonconfig-export.xml",
    [string]$InstallPath = "C:\Tools\Sysmon"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $InstallPath)) {
    New-Item -ItemType Directory -Path $InstallPath | Out-Null
}

$sysmonZip = Join-Path $InstallPath "Sysmon.zip"
$sysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"

Write-Host "Downloading Sysmon..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $sysmonUrl -OutFile $sysmonZip

Write-Host "Extracting Sysmon..." -ForegroundColor Cyan
Expand-Archive -Path $sysmonZip -DestinationPath $InstallPath -Force

$configPath = Join-Path $InstallPath "sysmonconfig.xml"
Write-Host "Downloading configuration..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $ConfigUrl -OutFile $configPath

$sysmonExe = Join-Path $InstallPath "Sysmon64.exe"
if (-not (Test-Path $sysmonExe)) {
    throw "Sysmon64.exe not found after extraction."
}

Write-Host "Installing / updating Sysmon..." -ForegroundColor Cyan
& $sysmonExe -accepteula -i $configPath

Write-Host "Sysmon installation complete."


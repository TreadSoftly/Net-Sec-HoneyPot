#requires -Version 5

<#
.SYNOPSIS
    Creates a sanitized evidence ZIP package for interviews.

.PARAMETER Output
    Destination ZIP file. Defaults to docs/evidence/net-sec-honeypot-evidence.zip.
#>

param(
    [string]$Output = "docs/evidence/net-sec-honeypot-evidence.zip"
)

$ErrorActionPreference = "Stop"

$sourcePaths = @(
    "docs/evidence/images",
    "docs/governance/control-matrix.md",
    "docs/runbooks",
    "detections"
)

$tempDir = Join-Path ([IO.Path]::GetTempPath()) ("evidence-" + [guid]::NewGuid())
New-Item -ItemType Directory -Path $tempDir | Out-Null

try {
    foreach ($path in $sourcePaths) {
        if (-not (Test-Path $path)) {
            Write-Warning "Skipping missing path: $path"
            continue
        }
        Copy-Item -Path $path -Destination $tempDir -Recurse
    }

    if (Test-Path $Output) {
        Remove-Item $Output
    }

    Compress-Archive -Path "$tempDir\*" -DestinationPath $Output
    Write-Host "Evidence pack created at $Output"
} finally {
    Remove-Item $tempDir -Recurse -Force
}

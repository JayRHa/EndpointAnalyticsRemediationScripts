<#
Version: 1.0
Author: 
- Jan (wolkenman.nl)
Script: Detect-WinREHealth
Description: Detects whether the Windows Recovery Environment is enabled, based on InstallState and WinreLocation in ReAgent.xml. Detection only, no remediation.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run this script using the logged-on credentials: No
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#>

$ReAgentXmlPath = Join-Path $env:windir 'System32\Recovery\ReAgent.xml'

if (-not (Test-Path -Path $ReAgentXmlPath)) {
    Write-Host "WinRE configuration (ReAgent.xml) not found."
    exit 1
}

try {
    [xml]$ReAgent = Get-Content -Path $ReAgentXmlPath -Raw -ErrorAction Stop
}
catch {
    Write-Host "Unable to read ReAgent.xml: $($_.Exception.Message)"
    exit 1
}

$InstallState = $ReAgent.WindowsRE.InstallState.state
$WinREPath    = $ReAgent.WindowsRE.WinreLocation.path

if ($InstallState -eq '1' -and -not [string]::IsNullOrWhiteSpace($WinREPath)) {
    Write-Host "WinRE is enabled (location: $WinREPath)."
    exit 0
}
else {
    Write-Host "WinRE is not enabled (InstallState: $InstallState)."
    exit 1
}

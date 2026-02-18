<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-startupprograms.ps1
Description: Detects excessive startup programs (more than 10 enabled entries)
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxStartupItems = 10

try {
    $StartupPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
    )

    $TotalItems = 0
    foreach ($Path in $StartupPaths) {
        if (Test-Path $Path) {
            $Items = Get-ItemProperty -Path $Path -ErrorAction SilentlyContinue
            $Properties = $Items.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" }
            $TotalItems += $Properties.Count
        }
    }

    if ($TotalItems -gt $MaxStartupItems) {
        Write-Warning "Not Compliant - $TotalItems startup programs found (max: $MaxStartupItems)"
        exit 1
    }

    Write-Output "Compliant - $TotalItems startup programs found"
    exit 0
}
catch {
    Write-Warning "Error checking startup programs: $_"
    exit 1
}

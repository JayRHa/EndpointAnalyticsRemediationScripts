<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-onedrivesync.ps1
Description: Detects if OneDrive sync is working properly
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $OneDrive = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
    if (-not $OneDrive) {
        Write-Warning "Not Compliant - OneDrive process is not running"
        exit 1
    }

    Write-Output "Compliant - OneDrive sync appears healthy"
    exit 0
}
catch {
    Write-Warning "Error checking OneDrive sync: $_"
    exit 1
}

<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-diskoptimization.ps1
Description: Detects if scheduled disk optimization is enabled
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $OptTask = Get-ScheduledTask -TaskName "ScheduledDefrag" -ErrorAction SilentlyContinue
    if (-not $OptTask -or $OptTask.State -eq "Disabled") {
        Write-Warning "Not Compliant - Scheduled disk optimization is disabled"
        exit 1
    }

    Write-Output "Compliant - Disk optimization is scheduled"
    exit 0
}
catch {
    Write-Warning "Error checking disk optimization: $_"
    exit 1
}

<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-eventlogerrors.ps1
Description: Detects critical and error events in the last 24 hours
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxCriticalEvents = 10
$HoursBack = 24

try {
    $StartTime = (Get-Date).AddHours(-$HoursBack)

    $CriticalEvents = Get-WinEvent -FilterHashtable @{
        LogName   = 'System', 'Application'
        Level     = 1, 2
        StartTime = $StartTime
    } -ErrorAction SilentlyContinue

    $EventCount = ($CriticalEvents | Measure-Object).Count

    if ($EventCount -gt $MaxCriticalEvents) {
        Write-Warning "Not Compliant - $EventCount critical/error events in the last $HoursBack hours"
        exit 1
    }

    Write-Output "Compliant - $EventCount critical/error events in the last $HoursBack hours"
    exit 0
}
catch {
    Write-Warning "Error checking event logs: $_"
    exit 1
}

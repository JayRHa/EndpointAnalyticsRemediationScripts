<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-pendingupdates.ps1
Description: Detects if there are pending Windows updates or reboot required
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $LastInstall = Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 1
    if ($LastInstall) {
        $DaysSinceUpdate = ((Get-Date) - $LastInstall.InstalledOn).Days
        if ($DaysSinceUpdate -gt 30) {
            Write-Warning "Not Compliant - Last update was $DaysSinceUpdate days ago"
            exit 1
        }
    }

    $PendingReboot = Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
    if ($PendingReboot) {
        Write-Warning "Not Compliant - Reboot pending for Windows Update"
        exit 1
    }

    Write-Output "Compliant - Windows Update is up to date"
    exit 0
}
catch {
    Write-Warning "Error checking updates: $_"
    exit 1
}

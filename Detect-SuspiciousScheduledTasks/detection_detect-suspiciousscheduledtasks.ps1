<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-suspiciousscheduledtasks.ps1
Description: Detects suspicious scheduled tasks not created by known vendors
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$KnownAuthors = @("Microsoft Corporation", "Microsoft", "Intel Corporation", "Dell", "HP", "Lenovo")

try {
    $Tasks = Get-ScheduledTask -ErrorAction Stop | Where-Object {
        $_.State -ne "Disabled" -and
        $_.TaskPath -notlike "\Microsoft\*" -and
        $_.Author -notin $KnownAuthors
    }

    $SuspiciousTasks = @()
    foreach ($Task in $Tasks) {
        if ($Task.TaskPath -notmatch "\\(Microsoft|Apple|Intel|Dell|HP|Lenovo)\\") {
            $SuspiciousTasks += "$($Task.TaskPath)$($Task.TaskName) (Author: $($Task.Author))"
        }
    }

    if ($SuspiciousTasks.Count -gt 0) {
        Write-Warning "Not Compliant - Found $($SuspiciousTasks.Count) suspicious scheduled tasks"
        $SuspiciousTasks | ForEach-Object { Write-Warning "  $_" }
        exit 1
    }

    Write-Output "Compliant - No suspicious scheduled tasks found"
    exit 0
}
catch {
    Write-Warning "Error checking scheduled tasks: $_"
    exit 1
}

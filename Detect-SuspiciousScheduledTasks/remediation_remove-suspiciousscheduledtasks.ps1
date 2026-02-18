<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: remove-suspiciousscheduledtasks.ps1
Description: Disables suspicious scheduled tasks not created by known vendors
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

    foreach ($Task in $Tasks) {
        if ($Task.TaskPath -notmatch "\\(Microsoft|Apple|Intel|Dell|HP|Lenovo)\\") {
            Disable-ScheduledTask -TaskName $Task.TaskName -TaskPath $Task.TaskPath -ErrorAction Stop
            Write-Output "Disabled: $($Task.TaskPath)$($Task.TaskName)"
        }
    }

    Write-Output "Suspicious scheduled tasks have been disabled"
    exit 0
}
catch {
    Write-Error "Failed to disable scheduled tasks: $_"
    exit 1
}

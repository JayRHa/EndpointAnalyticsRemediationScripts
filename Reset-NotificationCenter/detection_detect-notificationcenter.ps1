<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-notificationcenter.ps1
Description: Detects if the Notification Center database is oversized
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxSizeMB = 100

try {
    $UserProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue
    $NonCompliant = $false

    foreach ($Profile in $UserProfiles) {
        $NotifPath = Join-Path $Profile.FullName "AppData\Local\Microsoft\Windows\Notifications"
        if (Test-Path $NotifPath) {
            $Size = (Get-ChildItem -Path $NotifPath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $SizeMB = [math]::Round($Size / 1MB, 2)
            if ($SizeMB -gt $MaxSizeMB) {
                Write-Warning "Not Compliant - Notification database for $($Profile.Name) is $SizeMB MB"
                $NonCompliant = $true
            }
        }
    }

    if ($NonCompliant) { exit 1 }

    Write-Output "Compliant - Notification Center is within normal limits"
    exit 0
}
catch {
    Write-Warning "Error checking Notification Center: $_"
    exit 1
}

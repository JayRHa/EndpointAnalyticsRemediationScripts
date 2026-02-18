<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: reset-notificationcenter.ps1
Description: Resets the Windows Notification Center database
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $UserProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue

    foreach ($Profile in $UserProfiles) {
        $NotifPath = Join-Path $Profile.FullName "AppData\Local\Microsoft\Windows\Notifications"
        if (Test-Path $NotifPath) {
            Remove-Item -Path "$NotifPath\wpndatabase*" -Force -ErrorAction SilentlyContinue
            Write-Output "Reset notification database for: $($Profile.Name)"
        }
    }

    Stop-Service -Name WpnService -Force -ErrorAction SilentlyContinue
    Start-Service -Name WpnService -ErrorAction SilentlyContinue

    Write-Output "Notification Center has been reset successfully"
    exit 0
}
catch {
    Write-Error "Failed to reset Notification Center: $_"
    exit 1
}

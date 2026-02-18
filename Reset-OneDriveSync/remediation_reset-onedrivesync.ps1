<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: reset-onedrivesync.ps1
Description: Resets OneDrive sync client
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $OneDrivePaths = @(
        "$env:LOCALAPPDATA\Microsoft\OneDrive\onedrive.exe",
        "C:\Program Files\Microsoft OneDrive\onedrive.exe",
        "C:\Program Files (x86)\Microsoft OneDrive\onedrive.exe"
    )

    $OneDriveExe = $null
    foreach ($Path in $OneDrivePaths) {
        if (Test-Path $Path) { $OneDriveExe = $Path; break }
    }

    if (-not $OneDriveExe) {
        $UserOneDrive = Get-ChildItem "C:\Users\*\AppData\Local\Microsoft\OneDrive\onedrive.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($UserOneDrive) { $OneDriveExe = $UserOneDrive.FullName }
    }

    if (-not $OneDriveExe) {
        Write-Error "OneDrive executable not found"
        exit 1
    }

    Start-Process -FilePath $OneDriveExe -ArgumentList "/reset" -NoNewWindow -ErrorAction Stop
    Start-Sleep -Seconds 10
    Start-Process -FilePath $OneDriveExe -NoNewWindow -ErrorAction SilentlyContinue

    Write-Output "OneDrive sync has been reset successfully"
    exit 0
}
catch {
    Write-Error "Failed to reset OneDrive: $_"
    exit 1
}

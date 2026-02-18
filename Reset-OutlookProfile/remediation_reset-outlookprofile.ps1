<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: reset-outlookprofile.ps1
Description: Resets the Outlook profile by removing OST files
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    Get-Process -Name "OUTLOOK" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3

    $UserProfiles = Get-ChildItem "C:\Users" -Directory -ErrorAction SilentlyContinue

    foreach ($Profile in $UserProfiles) {
        $OutlookPath = Join-Path $Profile.FullName "AppData\Local\Microsoft\Outlook"
        if (Test-Path $OutlookPath) {
            Get-ChildItem -Path $OutlookPath -Filter "*.ost" -ErrorAction SilentlyContinue | ForEach-Object {
                Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
                Write-Output "Removed OST: $($_.Name) for $($Profile.Name)"
            }

            $RoamPath = Join-Path $OutlookPath "RoamCache"
            if (Test-Path $RoamPath) {
                Remove-Item -Path "$RoamPath\*" -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Write-Output "Outlook profile reset completed"
    exit 0
}
catch {
    Write-Error "Failed to reset Outlook profile: $_"
    exit 1
}

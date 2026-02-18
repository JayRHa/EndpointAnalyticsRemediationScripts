<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-savedwifiprofiles.ps1
Description: Detects saved WiFi profiles that use insecure authentication (Open/WEP)
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
        ($_ -split ":")[-1].Trim()
    }

    $InsecureProfiles = @()
    foreach ($Profile in $Profiles) {
        $Detail = netsh wlan show profile name="$Profile" key=clear 2>$null
        $Auth = ($Detail | Select-String "Authentication" | Select-Object -First 1) -replace ".*:\s*", ""
        if ($Auth -match "Open|WEP") {
            $InsecureProfiles += "$Profile ($Auth)"
        }
    }

    if ($InsecureProfiles.Count -gt 0) {
        Write-Warning "Not Compliant - Found $($InsecureProfiles.Count) insecure WiFi profiles"
        $InsecureProfiles | ForEach-Object { Write-Warning "  $_" }
        exit 1
    }

    Write-Output "Compliant - No insecure WiFi profiles found"
    exit 0
}
catch {
    Write-Warning "Error checking WiFi profiles: $_"
    exit 1
}

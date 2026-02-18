<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: remove-savedwifiprofiles.ps1
Description: Removes saved WiFi profiles that use insecure authentication (Open/WEP)
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
        ($_ -split ":")[-1].Trim()
    }

    $Removed = 0
    foreach ($Profile in $Profiles) {
        $Detail = netsh wlan show profile name="$Profile" key=clear 2>$null
        $Auth = ($Detail | Select-String "Authentication" | Select-Object -First 1) -replace ".*:\s*", ""
        if ($Auth -match "Open|WEP") {
            netsh wlan delete profile name="$Profile" | Out-Null
            Write-Output "Removed insecure WiFi profile: $Profile ($Auth)"
            $Removed++
        }
    }

    Write-Output "Removed $Removed insecure WiFi profiles"
    exit 0
}
catch {
    Write-Error "Failed to remove WiFi profiles: $_"
    exit 1
}

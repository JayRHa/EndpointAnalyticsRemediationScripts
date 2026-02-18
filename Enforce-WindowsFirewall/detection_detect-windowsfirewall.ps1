<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-windowsfirewall.ps1
Description: Detects if Windows Firewall is enabled on all profiles
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $FirewallProfiles = Get-NetFirewallProfile -ErrorAction Stop
    $NonCompliant = $false

    foreach ($Profile in $FirewallProfiles) {
        if ($Profile.Enabled -ne $true) {
            Write-Warning "Not Compliant - $($Profile.Name) firewall profile is disabled"
            $NonCompliant = $true
        }
    }

    if ($NonCompliant) { exit 1 }

    Write-Output "Compliant - All firewall profiles are enabled"
    exit 0
}
catch {
    Write-Warning "Not Compliant - Error checking firewall: $_"
    exit 1
}

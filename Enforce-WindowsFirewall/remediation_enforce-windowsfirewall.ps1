<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: enforce-windowsfirewall.ps1
Description: Enables Windows Firewall on all profiles
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True -ErrorAction Stop
    Write-Output "Windows Firewall enabled on all profiles successfully"
    exit 0
}
catch {
    Write-Error "Failed to enable Windows Firewall: $_"
    exit 1
}

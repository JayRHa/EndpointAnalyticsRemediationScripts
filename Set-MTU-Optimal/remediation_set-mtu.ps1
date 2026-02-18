<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: set-mtu.ps1
Description: Sets optimal MTU size on network adapters
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $ActiveAdapters = Get-NetIPInterface -AddressFamily IPv4 -ConnectionState Connected -ErrorAction Stop |
        Where-Object { $_.InterfaceAlias -notlike "Loopback*" }

    foreach ($Adapter in $ActiveAdapters) {
        $TargetMTU = if ($Adapter.InterfaceAlias -match "VPN|Tunnel") { 1400 } else { 1500 }

        if ($Adapter.NlMtu -ne $TargetMTU) {
            Set-NetIPInterface -InterfaceIndex $Adapter.InterfaceIndex -NlMtuBytes $TargetMTU -ErrorAction Stop
            Write-Output "Set MTU to $TargetMTU on $($Adapter.InterfaceAlias)"
        }
    }

    Write-Output "MTU settings optimized successfully"
    exit 0
}
catch {
    Write-Error "Failed to set MTU: $_"
    exit 1
}

<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-mtu.ps1
Description: Detects if the MTU size is optimal
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $ActiveAdapters = Get-NetIPInterface -AddressFamily IPv4 -ConnectionState Connected -ErrorAction Stop |
        Where-Object { $_.InterfaceAlias -notlike "Loopback*" }

    $NonCompliant = $false
    foreach ($Adapter in $ActiveAdapters) {
        $ExpectedMTU = if ($Adapter.InterfaceAlias -match "VPN|Tunnel") { 1400 } else { 1500 }

        if ($Adapter.NlMtu -ne $ExpectedMTU) {
            Write-Warning "Not Compliant - $($Adapter.InterfaceAlias): MTU is $($Adapter.NlMtu) (expected: $ExpectedMTU)"
            $NonCompliant = $true
        }
    }

    if ($NonCompliant) { exit 1 }

    Write-Output "Compliant - All adapters have optimal MTU"
    exit 0
}
catch {
    Write-Warning "Error checking MTU: $_"
    exit 1
}

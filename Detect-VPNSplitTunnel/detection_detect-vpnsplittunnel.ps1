<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-vpnsplittunnel.ps1
Description: Detects VPN connections configured with split tunneling
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $VpnConnections = Get-VpnConnection -AllUserConnection -ErrorAction SilentlyContinue
    $VpnConnections += Get-VpnConnection -ErrorAction SilentlyContinue

    if (-not $VpnConnections) {
        Write-Output "Compliant - No VPN connections configured"
        exit 0
    }

    $SplitTunnelVPNs = $VpnConnections | Where-Object { $_.SplitTunneling -eq $true }

    if ($SplitTunnelVPNs) {
        Write-Warning "Not Compliant - Split tunneling VPN connections found"
        $SplitTunnelVPNs | ForEach-Object { Write-Warning "  $($_.Name)" }
        exit 1
    }

    Write-Output "Compliant - No split tunnel VPN connections found"
    exit 0
}
catch {
    Write-Warning "Error checking VPN configurations: $_"
    exit 1
}

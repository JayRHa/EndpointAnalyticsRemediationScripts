<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: disable-vpnsplittunnel.ps1
Description: Disables split tunneling on all VPN connections
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $VpnConnections = @()
    $VpnConnections += Get-VpnConnection -AllUserConnection -ErrorAction SilentlyContinue
    $VpnConnections += Get-VpnConnection -ErrorAction SilentlyContinue

    foreach ($Vpn in $VpnConnections) {
        if ($Vpn.SplitTunneling -eq $true) {
            if ($Vpn.AllUserConnection) {
                Set-VpnConnection -Name $Vpn.Name -SplitTunneling $false -AllUserConnection -ErrorAction Stop
            }
            else {
                Set-VpnConnection -Name $Vpn.Name -SplitTunneling $false -ErrorAction Stop
            }
            Write-Output "Disabled split tunneling on: $($Vpn.Name)"
        }
    }

    Write-Output "Split tunneling has been disabled on all VPN connections"
    exit 0
}
catch {
    Write-Error "Failed to disable split tunneling: $_"
    exit 1
}

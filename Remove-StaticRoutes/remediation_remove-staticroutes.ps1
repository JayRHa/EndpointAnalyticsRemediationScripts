<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: remove-staticroutes.ps1
Description: Removes orphaned static routes with unreachable gateways
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $StaticRoutes = Get-NetRoute -AddressFamily IPv4 -ErrorAction Stop |
        Where-Object { $_.Protocol -eq "NetMgmt" -and $_.DestinationPrefix -ne "0.0.0.0/0" }

    $Removed = 0
    foreach ($Route in $StaticRoutes) {
        $Reachable = Test-Connection -ComputerName $Route.NextHop -Count 1 -Quiet -ErrorAction SilentlyContinue
        if (-not $Reachable) {
            Remove-NetRoute -DestinationPrefix $Route.DestinationPrefix -NextHop $Route.NextHop -Confirm:$false -ErrorAction Stop
            Write-Output "Removed orphaned route: $($Route.DestinationPrefix) via $($Route.NextHop)"
            $Removed++
        }
    }

    Write-Output "Removed $Removed orphaned static routes"
    exit 0
}
catch {
    Write-Error "Failed to remove static routes: $_"
    exit 1
}

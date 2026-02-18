<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-staticroutes.ps1
Description: Detects orphaned static routes with unreachable gateways
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $StaticRoutes = Get-NetRoute -AddressFamily IPv4 -ErrorAction Stop |
        Where-Object { $_.Protocol -eq "NetMgmt" -and $_.DestinationPrefix -ne "0.0.0.0/0" }

    if ($StaticRoutes.Count -gt 0) {
        Write-Warning "Not Compliant - Found $($StaticRoutes.Count) static routes"
        foreach ($Route in $StaticRoutes) {
            $Reachable = Test-Connection -ComputerName $Route.NextHop -Count 1 -Quiet -ErrorAction SilentlyContinue
            $Status = if ($Reachable) { "Reachable" } else { "Unreachable" }
            Write-Warning "  $($Route.DestinationPrefix) via $($Route.NextHop) - $Status"
        }
        exit 1
    }

    Write-Output "Compliant - No stale static routes found"
    exit 0
}
catch {
    Write-Warning "Error checking static routes: $_"
    exit 1
}

<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-driverissues.ps1
Description: Detects devices with driver problems
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $ProblemDevices = Get-PnpDevice -Status Error -ErrorAction SilentlyContinue
    $DegradedDevices = Get-PnpDevice -Status Degraded -ErrorAction SilentlyContinue

    $TotalIssues = @()
    if ($ProblemDevices) { $TotalIssues += $ProblemDevices }
    if ($DegradedDevices) { $TotalIssues += $DegradedDevices }

    if ($TotalIssues.Count -gt 0) {
        Write-Warning "Not Compliant - Found $($TotalIssues.Count) devices with driver issues"
        $TotalIssues | ForEach-Object { Write-Warning "  [$($_.Status)] $($_.FriendlyName)" }
        exit 1
    }

    Write-Output "Compliant - No driver issues found"
    exit 0
}
catch {
    Write-Warning "Error checking drivers: $_"
    exit 1
}

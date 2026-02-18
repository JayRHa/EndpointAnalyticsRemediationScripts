<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Enable-DNSOperationalLogsRemediation
Description: Enables DNS Client Operational logs
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $LogName = "Microsoft-Windows-DNS-Client/Operational"
    $Log = New-Object System.Diagnostics.Eventing.Reader.EventLogConfiguration $LogName
    $Log.IsEnabled = $true
    $Log.SaveChanges()
    Write-Output "DNS Operational Log has been enabled."
    exit 0
}
catch {
    Write-Error "Failed to enable DNS Operational Log: $_"
    exit 1
}

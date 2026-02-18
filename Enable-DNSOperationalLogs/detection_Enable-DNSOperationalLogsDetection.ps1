<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Enable-DNSOperationalLogsDetection
Description: Detects if DNS Client Operational logs are enabled
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $LogName = "Microsoft-Windows-DNS-Client/Operational"
    $Log = Get-WinEvent -ListLog $LogName -ErrorAction Stop

    if ($Log.IsEnabled) {
        Write-Output "DNS Operational Log is enabled."
        exit 0
    }
    else {
        Write-Output "DNS Operational Log is disabled."
        exit 1
    }
}
catch {
    Write-Error "Failed to check DNS Operational Log status: $_"
    exit 1
}

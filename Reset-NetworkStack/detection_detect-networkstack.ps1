<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-networkstack.ps1
Description: Detects network connectivity issues
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $DnsTest = Resolve-DnsName -Name "microsoft.com" -ErrorAction Stop
    $PingTest = Test-Connection -ComputerName "8.8.8.8" -Count 2 -Quiet

    if (-not $PingTest) {
        Write-Warning "Not Compliant - Network connectivity test failed"
        exit 1
    }

    Write-Output "Compliant - Network stack appears healthy"
    exit 0
}
catch {
    Write-Warning "Not Compliant - Network issues detected: $_"
    exit 1
}

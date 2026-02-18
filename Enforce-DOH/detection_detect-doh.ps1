<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-doh.ps1
Description: Detects if DNS over HTTPS (DoH) is enabled
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
    $DoHEnabled = Get-ItemProperty -Path $Path -Name "EnableAutoDoh" -ErrorAction SilentlyContinue

    if ($DoHEnabled -and $DoHEnabled.EnableAutoDoh -eq 2) {
        Write-Output "Compliant - DNS over HTTPS is enabled"
        exit 0
    }

    Write-Warning "Not Compliant - DNS over HTTPS is not enabled"
    exit 1
}
catch {
    Write-Warning "Not Compliant - Error checking DoH: $_"
    exit 1
}

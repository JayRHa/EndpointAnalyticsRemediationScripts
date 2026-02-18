<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: enforce-doh.ps1
Description: Enables DNS over HTTPS (DoH) system-wide
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters"
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }

    New-ItemProperty -Path $Path -Name "EnableAutoDoh" -Value 2 -PropertyType DWord -Force | Out-Null

    Write-Output "DNS over HTTPS has been enabled. A reboot may be required."
    exit 0
}
catch {
    Write-Error "Failed to enable DoH: $_"
    exit 1
}

<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: enforce-credentialguard.ps1
Description: Enables Credential Guard via registry
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Path = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    New-ItemProperty -Path $Path -Name "EnableVirtualizationBasedSecurity" -Value 1 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $Path -Name "RequirePlatformSecurityFeatures" -Value 1 -PropertyType DWord -Force | Out-Null

    $LsaPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    New-ItemProperty -Path $LsaPath -Name "LsaCfgFlags" -Value 1 -PropertyType DWord -Force | Out-Null

    Write-Output "Credential Guard has been enabled. A reboot is required."
    exit 0
}
catch {
    Write-Error "Failed to enable Credential Guard: $_"
    exit 1
}

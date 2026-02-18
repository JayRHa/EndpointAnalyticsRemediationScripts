<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: clear-browserextensions.ps1
Description: Blocks unapproved browser extensions via policy
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    # Chrome - block all extensions
    $ChromeBlocklist = "HKLM:\SOFTWARE\Policies\Google\Chrome\ExtensionInstallBlocklist"
    if (-not (Test-Path $ChromeBlocklist)) {
        New-Item -Path $ChromeBlocklist -Force | Out-Null
    }
    New-ItemProperty -Path $ChromeBlocklist -Name "1" -Value "*" -PropertyType String -Force | Out-Null

    # Edge - block all extensions
    $EdgeBlocklist = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallBlocklist"
    if (-not (Test-Path $EdgeBlocklist)) {
        New-Item -Path $EdgeBlocklist -Force | Out-Null
    }
    New-ItemProperty -Path $EdgeBlocklist -Name "1" -Value "*" -PropertyType String -Force | Out-Null

    Write-Output "Browser extension blocklist policy applied"
    exit 0
}
catch {
    Write-Error "Failed to apply extension policy: $_"
    exit 1
}

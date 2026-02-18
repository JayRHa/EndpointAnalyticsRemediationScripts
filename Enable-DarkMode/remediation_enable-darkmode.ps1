<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: enable-darkmode.ps1
Description: Enables system-wide dark mode
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }

    New-ItemProperty -Path $Path -Name "AppsUseLightTheme" -Value 0 -PropertyType DWord -Force | Out-Null
    New-ItemProperty -Path $Path -Name "SystemUsesLightTheme" -Value 0 -PropertyType DWord -Force | Out-Null

    Write-Output "Dark mode has been enabled system-wide"
    exit 0
}
catch {
    Write-Error "Failed to enable dark mode: $_"
    exit 1
}

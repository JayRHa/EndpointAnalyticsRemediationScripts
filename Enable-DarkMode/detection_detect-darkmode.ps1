<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-darkmode.ps1
Description: Detects if system-wide dark mode is enabled
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    $Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    $AppsUseLightTheme = Get-ItemProperty -Path $Path -Name "AppsUseLightTheme" -ErrorAction SilentlyContinue
    $SystemUsesLightTheme = Get-ItemProperty -Path $Path -Name "SystemUsesLightTheme" -ErrorAction SilentlyContinue

    if (($AppsUseLightTheme -and $AppsUseLightTheme.AppsUseLightTheme -eq 0) -and
        ($SystemUsesLightTheme -and $SystemUsesLightTheme.SystemUsesLightTheme -eq 0)) {
        Write-Output "Compliant - Dark mode is enabled"
        exit 0
    }

    Write-Warning "Not Compliant - Dark mode is not fully enabled"
    exit 1
}
catch {
    Write-Warning "Error checking dark mode: $_"
    exit 1
}

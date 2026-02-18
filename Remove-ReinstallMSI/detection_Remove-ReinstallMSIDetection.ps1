<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Remove-ReinstallMSIDetection
Description: Detects if a specified MSI application is installed and checks its version
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

# Configure the application to check
$AppName = "YourApplicationName"  # Display name of the MSI app (supports wildcards)
$DesiredVersion = ""               # Leave empty to just detect presence, or set e.g. "2.0.0" to check version

$Uninstall64 = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -like "*$AppName*" }
$Uninstall32 = Get-ItemProperty "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue |
    Where-Object { $_.DisplayName -like "*$AppName*" }

$InstalledApp = @($Uninstall64) + @($Uninstall32) | Where-Object { $_ -ne $null } | Select-Object -First 1

if (-not $InstalledApp) {
    Write-Output "$AppName is not installed."
    exit 1
}

if ($DesiredVersion -and $InstalledApp.DisplayVersion -ne $DesiredVersion) {
    Write-Output "$AppName version $($InstalledApp.DisplayVersion) found, expected $DesiredVersion."
    exit 1
}

Write-Output "$AppName version $($InstalledApp.DisplayVersion) is installed and compliant."
exit 0

<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Detect-AutologonRemediation
Description: Configures Windows Autologon via registry. IMPORTANT: Update the username and password variables before deployment.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

# IMPORTANT: Update these values before deploying
$AutologonUser = "YourUsername"
$AutologonDomain = "YourDomain"
$AutologonPassword = "YourPassword"  # Consider using a more secure method to store credentials

$WinlogonPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

try {
    Set-ItemProperty -Path $WinlogonPath -Name "AutoAdminLogon" -Value "1" -Force
    Set-ItemProperty -Path $WinlogonPath -Name "DefaultUserName" -Value $AutologonUser -Force
    Set-ItemProperty -Path $WinlogonPath -Name "DefaultDomainName" -Value $AutologonDomain -Force
    Set-ItemProperty -Path $WinlogonPath -Name "DefaultPassword" -Value $AutologonPassword -Force

    Write-Output "Autologon configured for user: $AutologonDomain\$AutologonUser"
    exit 0
}
catch {
    Write-Error "Failed to configure Autologon: $_"
    exit 1
}

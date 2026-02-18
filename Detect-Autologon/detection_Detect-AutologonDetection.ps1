<#
Version: 1.0
Author:
- Jannik Reinhard (jannikreinhard.com)
Script: Detect-AutologonDetection
Description: Detects if Windows Autologon is configured
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$WinlogonPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

try {
    $AutoAdminLogon = (Get-ItemProperty -Path $WinlogonPath -Name "AutoAdminLogon" -ErrorAction SilentlyContinue).AutoAdminLogon
    $DefaultUserName = (Get-ItemProperty -Path $WinlogonPath -Name "DefaultUserName" -ErrorAction SilentlyContinue).DefaultUserName

    if ($AutoAdminLogon -eq "1" -and $DefaultUserName) {
        Write-Output "Autologon is configured for user: $DefaultUserName"
        exit 0
    }
    else {
        Write-Output "Autologon is not configured."
        exit 1
    }
}
catch {
    Write-Error "Failed to check Autologon status: $_"
    exit 1
}

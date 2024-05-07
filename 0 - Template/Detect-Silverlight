<#
Version: 1.0
Author: 
- Gerardo Hernandez
Script: Detect-Silverlight
Description: Script detects the Microsoft Silverlight
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run this script using the logged-on credentials: No
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#> 

$Uninstall = (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -eq "Microsoft Silverlight" } | Select-Object -Property UninstallString).UninstallString
if ($Uninstall) {
    Write-Output "Microsoft Silverlight was found"
    Exit 1
    }else { 
    Write-Output "Microsoft Silverlight not found"
    Exit 0
}

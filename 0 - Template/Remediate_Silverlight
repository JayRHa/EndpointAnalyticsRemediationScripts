<#
Version: 1.0
Author: 
- Gerardo Hernandez
Script: Remove-Silverlight
Description: Script removes the Microsoft Silverlight
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run this script using the logged-on credentials: No
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#> 

$Uninstall = (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -eq "Microsoft Silverlight" } | Select-Object -Property UninstallString).UninstallString
$Uninstall=$Uninstall.split(" ")[1]
Start-Process msiexec.exe -ArgumentList "$Uninstall /quiet" -Wait
Exit 0

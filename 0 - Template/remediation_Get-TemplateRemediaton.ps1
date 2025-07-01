<#
Version: 1.0
Author: 
- Jeroen Burgerhout (burgerhout.org)
Script: Remove-OutlookNew
Description: Script removes the new Microsoft Outlook app on Windows 11 23H2.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run this script using the logged-on credentials: Yes
Enforce script signature check: No
Run script in 64-bit PowerShell: Yes
#> 

try{
    Get-AppxPackage -Name *OutlookForWindows* | Remove-AppxPackage -ErrorAction stop
    Write-Host "Microsoft Outlook (New) successfully removed."

}
catch{
    Write-Error "Error removing Microsoft Outlook (New)."
}

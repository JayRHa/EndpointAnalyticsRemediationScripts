<#
Version: 1.0
Author: Niklas Rast (niklasrast.com)
Script: detection.ps1
Description: This script checks if the branding is set correctly.
Hint: 
Version: 1.0
Run as: Admin
Context: 64 Bit
#> 

$BrandingContent = @"
RegKeyPath,Key,Value
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation","SupportURL","https://your-support-page/"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation","Manufacturer","your company name"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation","SupportHours","your support hours"
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation","SupportPhone","your support phone"
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion","RegisteredOwner","your company name"
"HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion","RegisteredOrganization","your company name"
"@

$Branding = $BrandingContent | ConvertFrom-Csv -delimiter ","

foreach ($Brand in $Branding) {
    $ExistingValue = (Get-Item -Path $($Brand.RegKeyPath)).GetValue($($Brand.Key))
    if ($ExistingValue -ne $($Brand.Value)) {
      Write-Host $($Brand.Key) "Not Equal"
      Exit 1
      Exit #Remediation 
    }
    else {
#      Write-Host $($Brand.Key) "Equal"
    }
}
Exit 0
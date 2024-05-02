<#
Version: 1.0
Author: Niklas Rast (niklasrast.com)
Script: remediation.ps1
Description: This script sets the branding information for the system.
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

    IF (!(Test-Path ($Brand.RegKeyPath))) {
        Write-Host ($Brand.RegKeyPath) " does not exist. Will be created."
        New-Item -Path $RegKeyPath -Force | Out-Null
    }
    IF (!(Get-Item -Path $($Brand.Key))) {
        Write Host $($Brand.Key) " does not exist. Will be created."
        New-ItemProperty -Path $($Brand.RegKeyPath) -Name $($Brand.Key) -Value $($Brand.Value) -PropertyType STRING -Force
    }
    
    $ExistingValue = (Get-Item -Path $($Brand.RegKeyPath)).GetValue($($Brand.Key))
    if ($ExistingValue -ne $($Brand.Value)) {
        Write-Host $($Brand.Key) " not correct value. Will be set."
        Set-ItemProperty -Path $($Brand.RegKeyPath) -Name $($Brand.Key) -Value $($Brand.Value) -Force
    }
    else {
        Write-Host $($Brand.Key) " is correct"
    }
}

Exit 0

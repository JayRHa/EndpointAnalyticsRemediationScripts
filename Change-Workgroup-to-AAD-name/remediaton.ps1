<#
Version: 1.0
Author: Niklas Rast (niklasrast.com)
Script: remediaton.ps1
Description: This script changes the workgroup name to the AAD name.
Hint: 
Version: 1.0
Run as: Admin
Context: 64 Bit
#> 

#Get AAD Tenant ID
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo"
$TenantInfoPath = (Get-ChildItem -Path $regPath).Name
$parentPart = Split-Path $TenantInfoPath -Parent
$AADTenantID = Split-Path $TenantInfoPath -Leaf

#Get AAD Name
$AADName = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\$AADTenantID" -Name DisplayName).DisplayName

#Install Customer Workgroup
Add-Computer -WorkGroupName "$AADName"
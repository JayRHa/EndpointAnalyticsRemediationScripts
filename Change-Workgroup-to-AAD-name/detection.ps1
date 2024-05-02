<#
Version: 1.0
Author: Niklas Rast (niklasrast.com)
Script: detection.ps1
Description: This script checks if the current workgroup name is equal to the AAD name.
Hint: 
Version: 1.0
Run as: Admin
Context: 64 Bit
#> 

#Get AAD Tenant ID and Name
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo"
$TenantInfoPath = (Get-ChildItem -Path $regPath).Name
$parentPart = Split-Path $TenantInfoPath -Parent
$AADTenantID = Split-Path $TenantInfoPath -Leaf
$AADName = (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CloudDomainJoin\TenantInfo\$AADTenantID" -Name DisplayName).DisplayName

$CurrentWorkgroupName = (Get-WmiObject -Class Win32_ComputerSystem).Domain

if($CurrentWorkgroupName -ne $AADName){
    return 0
}else{
    return 1
}

<#
Version: 1.0
Author: 
- Adam Gell
Script: remediate-automatictimezone.ps1
Description: Sets up Automatic Timezone and Time Sync
Release notes:
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

##Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
$regpath2 = "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate"
##Enter the name of the registry key for example EnableLUA
$regname = "Value"
$regname2 = "start"
##Enter the value of the registry key we are checking for, for example 0
$regvalue = "Allow"
$regvalue2 = "3"

##Enter the type of the registry key for example DWord
$regtype = "STRING"
$regtype2 = "DWORD"


New-ItemProperty -LiteralPath $regpath -Name $regname -Value $regvalue -PropertyType $regtype -Force -ea SilentlyContinue;
New-ItemProperty -LiteralPath $regpath2 -Name $regname2 -Value $regvalue2 -PropertyType $regtype -Force -ea SilentlyContinue;

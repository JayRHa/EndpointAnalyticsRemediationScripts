<#
Version: 1.0
Author: 
- Adam Gell
Script: remediate-coinstaller.ps1
Description: Detects if coinstallers is disabled via registry key
Release notes:
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

##Enter the path to the registry key
$regpath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer"

##Enter the name of the registry key 
$regname = "DisableCoInstallers"

##Enter the value of the registry key
$regvalue = "00000001"

##Enter the type of the registry key for example DWord
$regtype = "DWord"


New-ItemProperty -LiteralPath $regpath -Name $regname -Value $regvalue -PropertyType $regtype -Force -ea SilentlyContinue;
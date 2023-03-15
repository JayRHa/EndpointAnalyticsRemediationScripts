<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: remediate-fastboot.ps1
Description: Disables Fastboot via registry key
Release notes:
Version 1.0: Init
Run as: Admin/User
Context: 64 Bit
#> 

##Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = ""

##Enter the name of the registry key for example EnableLUA
$regname = ""

##Enter the value of the registry key for example 0
$regvalue = ""

##Enter the type of the registry key for example DWord
$regtype = ""


New-ItemProperty -LiteralPath $regpath -Name $regname -Value $regvalue -PropertyType $regtype -Force -ea SilentlyContinue;
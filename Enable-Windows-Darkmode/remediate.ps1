<#
Version: 1.0
Author: Niklas Rast (niklasrast.com)
Script: remediate.ps1
Description: This script enables the dark mode on the users system.
Hint: 
Version: 1.0
Run as: User
Context: 64 Bit
#> 

$regpath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$regname = "AppsUseLightTheme"
$regname1 = "SystemUsesLightTheme"
$regvalue = "0"
$regtype = "DWORD"


New-ItemProperty -LiteralPath $regpath -Name $regname -Value $regvalue -PropertyType $regtype -Force -ea SilentlyContinue
New-ItemProperty -LiteralPath $regpath -Name $regname1 -Value $regvalue -PropertyType $regtype -Force -ea SilentlyContinue
<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Remediate-Always_Elevated
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 32 & 64 Bit
#> 

$Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\"
$Key = "Installer"
$FullPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$Name = "AlwaysInstallElevated"
$Type = "DWORD"
$Value = "0"


New-Item -Path $Path -Name $Key
New-ItemProperty -Path $FullPath -Name $Name -Value $Value  -PropertyType $Type

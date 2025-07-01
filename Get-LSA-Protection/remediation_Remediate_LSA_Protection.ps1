<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Remediate_LSA_Protection
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 32 & 64 Bit
#> 

$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$Name = "RunAsPPL"
$Type = "DWORD"
$Value = 1

Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value 
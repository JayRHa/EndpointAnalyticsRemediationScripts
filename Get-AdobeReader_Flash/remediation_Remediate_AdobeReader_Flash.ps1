<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Remediate-AdobeReader_Flash
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User/Admin
Context: 32 & 64 Bit
#> 

New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" -Name "bEnableFlash" -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;

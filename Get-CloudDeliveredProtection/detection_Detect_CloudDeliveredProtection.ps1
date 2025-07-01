<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Get-CloudDeliveredProtection
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 32 & 64 Bit
#> 

$version = 'C1'
if(((Get-MpPreference).MAPSReporting -eq 2) -and ((Get-MpPreference).SubmitSamplesConsent) -eq 3) {
    Write-Output "$version COMPLIANT"
    exit 0
} else {
    Write-Output "$version NON-COMPLIANT"
    exit 1
}
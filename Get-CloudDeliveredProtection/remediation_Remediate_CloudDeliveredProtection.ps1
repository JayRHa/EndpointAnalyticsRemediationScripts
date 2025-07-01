<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Remediate-CloudDeliveredProtection
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 32 & 64 Bit
#> 

$version = 'R1'
try {
    Set-MpPreference -MAPSReporting Advanced
    Set-MpPreference -SubmitSamplesConsent SendAllSamples
    Write-Output "$version Remediated"
    exit 0
}
catch {
    Write-Output "$version Failed"
    exit 1
}
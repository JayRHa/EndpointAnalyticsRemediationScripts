<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Nico Wyss (https://cloudfil.ch)
Script: DetectDotNet35.ps1
Description: Detects if .NET 3.5 is installed
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 
Start-Transcript -Path $(Join-Path $env:temp "NetFx3.log")
 
if ((Get-WindowsOptionalFeature -Online -FeatureName NetFx3).State -eq "Enabled") {
    Write-Output 'NetFx3 Enabled'
    exit 0
}
else {
    Write-Output 'NetFx3 Disabled'
    exit 1
}
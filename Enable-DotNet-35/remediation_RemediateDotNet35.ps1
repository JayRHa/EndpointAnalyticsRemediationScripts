<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Nico Wyss (https://cloudfil.ch)
Script: RemediateDotNet35.ps1
Description: Installs .NET 3.5
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

try  {
 
    Enable-WindowsOptionalFeature -Online -FeatureName NetFx3
    Write-Output 'NetFx3 will be Enabled'
    exit 0
}
catch {
 
    $errMsg = $_.Exception.Message
    Write-host $errMsg
    exit 1
}
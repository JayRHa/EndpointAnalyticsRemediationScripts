<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Remediate-Office_Telemetry
Description: Disable O365 from sharing telemetry
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 32 & 64 Bit
#> 

$Path = "HKCU:\Software\Policies\Microsoft\office\common\"
$Key = "clienttelemetry"
$FullPath = "HKCU:\Software\Policies\Microsoft\office\common\clienttelemetry"
$Name = "DisableTelemetry"
$Type = "DWORD"
$Value = "1"

New-Item -Path $Path -Name $Key
New-ItemProperty -Path $FullPath -Name $Name -Value $Value  -PropertyType $Type

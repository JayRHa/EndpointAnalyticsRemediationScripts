<#
Version: 1.0
Author:
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Sascha Stumpler (sastu@master-client.com)
Script: set-service.ps1
Description: Restarts any service
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$servicename = "ServiceName"
$serviceOption = 'serviceOption'
$serviceOptionValue = 'serviceOptionValue'
$SetServiceSplat = @{
	Name = $ServiceName
	$serviceOption = $serviceOptionValue
}

Set-Service @SetServiceSplat
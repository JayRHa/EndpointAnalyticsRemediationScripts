<#
Version: 1.0
Author:
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Sascha Stumpler (sastu@master-client.com)
Script: detect-service.ps1
Description: Detects if service exists and is configured as expected
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$servicename = "ServiceName"
$serviceOption = 'serviceOption'
$serviceOptionValue = 'serviceOptionValue'
$ServiceObject = Get-Service -Name $servicename -ErrorAction SilentlyContinue

$checkarray = 0
if (($null -ne $ServiceObject) -and ($ServiceObject.$serviceOption -eq $serviceOptionValue)) {
    $checkarray++
}

if ($checkarray -ne 0) {
    Write-Host "Service is available and correctly configured"
    exit 0
} else {
    Write-Host "Service is not available or correctly configured"
    exit 1
}
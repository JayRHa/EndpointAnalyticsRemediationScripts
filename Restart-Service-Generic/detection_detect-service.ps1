<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-service.ps1
Description: Detects if service exists and is running
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

$servicename = "ServiceName"

$checkarray = 0

$serviceexist = Get-Service -Name $servicename -ErrorAction SilentlyContinue
if ($null -ne $serviceexist) {
    $checkarray++
}

$servicerunning = Get-Service -Name $servicename | Where-Object {$_.Status -eq "Running"}
if ($null -ne $servicerunning) {
    $checkarray++
}

if ($checkarray -ne 0) {
    Write-Host "Service is available and running"
    exit 0
} else {
    Write-Host "Service is not there/running"
    exit 1
}
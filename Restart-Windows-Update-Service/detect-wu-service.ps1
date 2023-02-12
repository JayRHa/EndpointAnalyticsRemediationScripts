<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-service.ps1
Description: Detects if Windows Update exists and is running
Release notes:
Version 1.0: Init
#> 

$servicename = "wuauserv"

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
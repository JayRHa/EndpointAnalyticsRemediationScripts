<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: restart-service.ps1
Description: Restarts any service
Release notes:
Version 1.0: Init
#> 

$servicename = "ServiceName"

Restart-Service -Name $servicename -Force
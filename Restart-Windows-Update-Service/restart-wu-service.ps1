<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: restart-service.ps1
Description: Restarts Windows Update service
Release notes:
Version 1.0: Init
#> 

$servicename = "wuauserv"

Restart-Service -Name $servicename -Force
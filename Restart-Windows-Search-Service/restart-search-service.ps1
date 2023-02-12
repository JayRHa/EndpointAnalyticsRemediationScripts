<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: restart-search-service.ps1
Description: Restarts Windows Search service
Release notes:
Version 1.0: Init
#> 

$servicename = "WSearch"

Restart-Service -Name $servicename -Force
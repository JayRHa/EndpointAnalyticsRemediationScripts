<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Simon Skotheimsvik (skotheimsvik.no)
Script: Create-LocalAdmin
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$localAdminName = ""

if(Get-LocalUser | where-Object Name -eq $localAdminName){
    Write-Host "User does already exist"
    Exit 0
}else{
    Write-Host "User does not exist"
    Exit 1
}

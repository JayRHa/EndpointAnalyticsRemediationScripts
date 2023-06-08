<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Create-LocalAdmin
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$localAdminName = ""
$password = ""

New-LocalUser "$localAdminName" -Password $password -FullName "$localAdminName" -Description "Temp local admin"
Add-LocalGroupMember -Group "Administrators" -Member "$localAdminName"

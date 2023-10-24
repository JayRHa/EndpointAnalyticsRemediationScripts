<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Simon Skotheimsvik (skotheimsvik.no)
Script: Create-LocalAdmin
Description: Add a local admin with a randomized password, ensuring that we do not have an account with a static password across all devices before Windows LAPS takes effect.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.1: Init
Run as: Admin
Context: 64 Bit
#> 

$localAdminName = ""
$password = -join ((65..90) + (97..122) + (48..57) + (35..38) + (40..47) | Get-Random -Count 35 | ForEach-Object {[char]$_}) | ConvertTo-SecureString -AsPlainText -Force
$Localadmingroupname = $((Get-LocalGroup -SID "S-1-5-32-544").Name)

New-LocalUser "$localAdminName" -Password $password -FullName "$localAdminName" -Description "LAPS account"
Add-LocalGroupMember -Group $Localadmingroupname -Member "$localAdminName"

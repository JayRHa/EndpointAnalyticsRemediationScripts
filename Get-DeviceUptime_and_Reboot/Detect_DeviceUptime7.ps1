<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Get_DeviceUptime7
Description: Checks the device uptime days. If its 7 days or more it shows a windows notification to the user that he should reboot.
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 

$Uptime= get-computerinfo | Select-Object OSUptime 
if ($Uptime.OsUptime.Days -ge 7){
    Write-Output "Device has not rebootet on $($Uptime.OsUptime.Days) days, notify user to reboot"
    Exit 1
}else {
    Write-Output "Device has rebootet $($Uptime.OsUptime.Days) days ago, all good"
    Exit 0
}
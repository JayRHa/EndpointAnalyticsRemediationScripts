<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-fastboot.ps1
Description: Detects if machine has been on for more than 7 days
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

##Check how long machine has been on for
$now = Get-Date -UFormat "%s" -Date (Get-Date)
$poweron = (Get-Date -UFormat "%s" -Date (Get-Process -Id $pid).StartTime)

##Check the difference between the two
$diff = $now - $poweron

##Convert that to hours
$hours = $diff / 3600

##How long shall we compare against in days??
$thresholddays = 7

##Convert that to hours
$thresholdhours = $thresholddays * 24

if ($hours -gt $thresholdhours) {
    write-host "Machine has been on for more than $thresholddays days"
    exit 0
}
else {
    write-host "Machine has been on for less than $thresholddays days"
    exit 1
}

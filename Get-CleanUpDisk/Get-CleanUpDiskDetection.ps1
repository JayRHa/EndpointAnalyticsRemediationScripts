<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Get-CleanUpDisk
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$storageThreshold = 15

$utilization = (Get-PSDrive | Where {$_.name -eq "C"}).free

if(($storageThreshold *1GB) -lt $utilization){exit 0}
else{exit 1}
<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-old-profiles.ps1
Description: Checks for disk errors
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 
$disk = ($env:SystemDrive).Substring(0,1)

$repair = repair-volume -DriveLetter $disk -scan -Verbose

write-output $repair

if ($repair -eq "NoErrorsfound") {
write-host "No issues"
Exit 0
}
else {
write-host "Needs checking"
exit 1
}
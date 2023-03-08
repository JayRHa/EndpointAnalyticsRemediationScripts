<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-backup.ps1
Description: Detects if backup has been run in the last hour
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 
$todaysdate = Get-Date -Format "dd-MM-yyyy-HH"
$dir = $env:APPDATA + "\backup-restore"

##Open File to check contents
$backupfile = $dir + "\backup.txt"
$backupdate = Get-Content -Path $backupfile
$checkdate = (get-date $backupdate -Format "dd-MM-yyyy-HH")
##Check if date is more than 1 hour ago
if ($checkdate -lt $todaysdate) {
    write-host "Run again"
    exit 1
}
else {
    "Already run this hour"
    exit 0
}
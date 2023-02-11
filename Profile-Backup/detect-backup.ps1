<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-backup.ps1
Description: Detects if backup has been run in the last hour
Release notes:
Version 1.0: Init
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
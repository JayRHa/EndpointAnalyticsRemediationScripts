<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-old-profiles.ps1
Description: Detects if there are profiles older than 30 days
Release notes:
Version 1.0: Init
#> 
$days = 30
$profiles = (get-CimInstance win32_userprofile | Where-Object {$_.LastUseTime -lt $(Get-Date).Date.AddDays(-$days)})
$profilecount = $profiles.Count
if ($profilecount -gt 0) {
write-host "There are profiles to remove" -ForegroundColor Red
Exit 1
}
else {
write-host "No old profiles to remove" -ForegroundColor Green
Exit 0
}
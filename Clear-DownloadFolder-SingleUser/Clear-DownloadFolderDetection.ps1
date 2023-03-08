<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Clear-DownloadFolder
Description: Checks if there is anything in the download folder
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 

##Check if there is anything in there
$path = "$env:USERPROFILE\Downloads"
$content = Get-ChildItem $path
if ($content.count -gt 0) {
    write-host "things to remove"
    exit 1
}
else {
    write-host "nothing to remove"
    exit 0
}

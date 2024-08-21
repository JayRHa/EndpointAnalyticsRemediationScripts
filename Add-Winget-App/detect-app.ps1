<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-app.ps1
Description: Detects if app exists
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

$appid = ""

$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
if ($ResolveWingetPath){
       $WingetPath = $ResolveWingetPath[-1].Path
}else{
       exit 0
}
start-sleep -seconds 10

$Winget = $WingetPath + "\winget.exe"
$wingettest = &$winget list --id $appid
if ($wingettest -like "*$appid*"){
Write-Host "Found it!"
exit 0
}
else {
write-host "Not Found"
exit 1
}

<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: remediate-app.ps1
Description: Installs app via Winget
Release notes:
Version 1.0: Init
#> 

$appid = ""

$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
if ($ResolveWingetPath){
       $WingetPath = $ResolveWingetPath[-1].Path
}

$Winget = $WingetPath + "\winget.exe"
&$winget install --id $appid --silent --force --accept-package-agreements --accept-source-agreements --scope machine --exact | out-null
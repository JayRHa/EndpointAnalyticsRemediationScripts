<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: remediate-store.ps1
Description: Unpins the Windows Store from the taskbar
Release notes:
Version 1.0: Init
#> 
$apps = ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items())
foreach ($app in $apps) {
$appname = $app.Name
if ($appname -like "*store*") {
$finalname = $app.Name
}
}

((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | Where-Object{$_.Name -eq $finalname}).Verbs() | Where-Object{$_.Name.replace('&','') -match 'Unpin from taskbar'} | ForEach-Object{$_.DoIt(); $exec = $true}

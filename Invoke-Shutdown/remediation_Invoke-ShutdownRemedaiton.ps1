<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Invoke-Shutdown
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin/User
Context: 64 Bit
#> 

$timeout = 60
Add-Type -AssemblyName PresentationCore,PresentationFramework
$msgBody = "Shutdown triggered in $timeout seconds"
[System.Windows.MessageBox]::Show($msgBody)


shutdown /r /t $timeout /d p:0:0
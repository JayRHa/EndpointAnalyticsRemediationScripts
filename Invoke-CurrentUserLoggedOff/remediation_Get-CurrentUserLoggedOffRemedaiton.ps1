<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Get-TemplateRemediation
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 

$timeout = 60
Add-Type -AssemblyName PresentationCore,PresentationFramework
$msgBody = "You will be logged out in $timeout seconds"
[System.Windows.MessageBox]::Show($msgBody)


shutdown /L /f $timeout
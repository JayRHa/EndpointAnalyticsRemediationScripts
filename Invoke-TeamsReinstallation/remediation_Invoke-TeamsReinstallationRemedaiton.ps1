<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Invoke-TeamsReinstallation
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

$MachineWide = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "Teams Machine-Wide Installer"}
$MachineWide.Uninstall()

$url = 'https://aka.ms/teams64bitmsi'
$client = new-object System.Net.WebClient
$client.DownloadFile($url,$TeamsPath) 

$return = Start-Process msiexec.exe -Wait -ArgumentList "/I $TeamsPath /qn /norestart"  -PassThru

if(@(0,3010) -contains $return.ExitCode){
return 'Installed'
}
else{
return 'Error Installing'
}

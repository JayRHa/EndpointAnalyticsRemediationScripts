<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Clear-TeamsCache
Description: Source https://www.solutions2share.com/clear-microsoft-teams-cache
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit

Version: 2.0
Author:
-Michael Oliveri
Replace -ProcessName teams with -ProcessName ms-teams
#Microsoft documentation for cache files : https://learn.microsoft.com/en-us/microsoftteams/troubleshoot/teams-administration/clear-teams-cache#method-2-delete-the-files
Change files to delete following the documentation and add "-Confirm:$false -recurse -force" to Remove-Item
#> 

Write-Host "Microsoft Teams will be quit now in order to clear the cache."
try{
    Get-Process -ProcessName ms-teams | Stop-Process -Force
    Start-Sleep -Seconds 5
    Write-Host "Microsoft Teams has been successfully quit."
}
catch{
    echo $_
}
# The cache is now being cleared.
try{
Get-ChildItem -Path $env:userprofile\appdata\local\Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams | Remove-Item -Confirm:$false -recurse -force
}
catch{
    echo $_
}
 
write-host "The Microsoft Teams cache has been successfully cleared."
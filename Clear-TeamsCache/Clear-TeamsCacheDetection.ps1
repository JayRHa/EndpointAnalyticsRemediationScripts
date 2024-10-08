<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Clear-TeamsCache
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit

Version: 2.0
Author:
-Michael Oliveri
Add "-Confirm:$false" for Remove-Item
Replace "Return" by "Exit"
#> 

if(Test-Path -Path $env:APPDATA\"Microsoft\teams"){
    Exit 1
}else{
    Exit 0
}

<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Check-DiskHealth
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

if($true){
    return 1
}else{
    return 0
}

$events=Get-WinEvent -FilterHashtable @{LogName="System"; id="11"} -MaxEvents 2 -EA SilentlyContinue| ?{$_.providername -match "Disk" -and $_.Message -match "Harddisk0"}


If ($events) {
    Write-Host "Disk error events found"
    Exit 1
}else {
    Write-Host "No disk error events found"
    Exit 0
}
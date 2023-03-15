<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Get-ConnectedDevices
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin/User
Context: 64 Bit
#> 

$deviceIds = @('')

foreach($device in Get-PnpDevice){
    if(($deviceIds | %{$device.DeviceID -like "$_*"}) -contains $true){
        Write-Host "Device found"
        Exit 1
    }
}

Write-Host "Device not found"
Exit 0
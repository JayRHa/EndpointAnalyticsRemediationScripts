<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Marius Wyss (marius.wyss@microsoft.com)
Script: Check-PNPDevicesDetection.ps1
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

# Check if there are Devices that do not work properly, 
# see README.md for more information on the filters

$ClassFilterExclude = ""
$ClassFilterInclude = "*"
$DeviceIDFilterExclude = ""
$DeviceIDFilterInclude = "*"

[array]$DevicesWithIssue = Get-PnpDevice -PresentOnly -Status ERROR -ErrorAction SilentlyContinue | 
    Where-Object PNPClass -notin $ClassFilterExclude | 
    Where-Object {if ("*" -in $ClassFilterInclude) { $_} elseif ($_.PNPClass -in $ClassFilterInclude) {$_}} |
    Where-Object PNPDeviceID -notin $DeviceIDFilterExclude | 
    Where-Object {if ("*" -in $DeviceIDFilterInclude) { $_} elseif ($_.PNPDeviceID -in $DeviceIDFilterInclude) {$_}}

$Output = ""
if ($DevicesWithIssue.count -gt 0) {
    Foreach ($Device in $DevicesWithIssue) {
        $FriendlyName = if ([string]::IsNullOrWhiteSpace($Device.FriendlyName)) {"N/A"} else {$Device.FriendlyName}
        $PNPClass = if ([string]::IsNullOrWhiteSpace($Device.PNPClass)) {"N/A"} else {$Device.PNPClass}
        
        Write-Verbose "Device: $FriendlyName Class: $PNPClass PNPDeviceID: $($Device.PNPDeviceID) ConfigManagerErrorCode: $($Device.ConfigManagerErrorCode)"
        $Output += " | Device: $FriendlyName Class: $PNPClass PNPDeviceID: $($Device.PNPDeviceID) Err: $($Device.ConfigManagerErrorCode)"
    }
    Write-Host $Output.TrimStart(" |")
    exit 1
}
else {
    Write-Host "No Devices with issues found"
    exit 0
}

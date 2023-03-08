<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-fastboot.ps1
Description: Detects if Fastboot is enabled
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
#> 

$smbv1 = get-smbserverconfiguration | Select-Object -ExpandProperty EnableSMB1Protocol
if ($smbv1 -eq $false) {
    write-host "SMBv1 is disabled"
    exit 0
}
else {
    write-host "SMBv1 is enabled"
    exit 1
}
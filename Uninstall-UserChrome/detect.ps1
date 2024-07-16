<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Adam Gell
Script: detect.ps1
Description: uninstalls if app exists, only checks/uninstalls per-user Chrome in HKCU
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 

$blacklistapps = @(
    "Google Chrome"
)

$counter = 0
$InstalledSoftware = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString, DisplayName_Localized
foreach ($obj in $InstalledSoftware) {
    $name = $obj.DisplayName
    if ($null -eq $name) {
        $name = $obj.DisplayName_Localized
    }
    if (($blacklistapps -contains $name)) {
        $counter++
    }

}

if ($counter -eq 0) {
    write-output "Per-User Chrome Not detected"
    exit 0
}
else {
    write-output "Per-User Chrome Detected. Switching the device over to the Enterprise version."
    exit 1
}

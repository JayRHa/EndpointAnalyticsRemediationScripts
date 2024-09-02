<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
- Adam Gell 
Script: remediate.ps1\
Description: uninstalls if app exists, only checks/uninstalls per-user Chrome in HKCU
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 64 Bit
#> 

$blacklistapps = @(
    "Google Chrome"
)

$InstalledSoftware = Get-ChildItem "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString, DisplayName_Localized
foreach ($obj in $InstalledSoftware) {
    $name = $obj.DisplayName
    if ($null -eq $name) {
        $name = $obj.DisplayName_Localized
    }
    if (($blacklistapps -contains $name) -and ($null -ne $obj.UninstallString)) {
        $uninstallcommand = $obj.UninstallString
        write-host "Removing $name, and adding a force-uninstall flag to make it silent"
        if ($uninstallcommand -like "*msiexec*") {
            $splitcommand = $uninstallcommand.Split("{")
            $msicode = $splitcommand[1]
            $uninstallapp = "msiexec.exe /X {$msicode /qn"
            start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
        }
        else {
            $splitcommand = $uninstallcommand.Split("{")
        
            $uninstallapp = "$uninstallcommand /S"
            start-process "cmd.exe" -ArgumentList "/c $uninstallapp --force-uninstall"
        }
    }

}



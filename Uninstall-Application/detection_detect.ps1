<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-app.ps1
Description: Detects if app exists
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

$blacklistapps = @(
    "APP 1"
    "APP 2"
)

$counter = 0
 $InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString, DisplayName_Localized
 foreach($obj in $InstalledSoftware){
     $name = $obj.DisplayName
     if ($null -eq $name) {
         $name = $obj.DisplayName_Localized
     }
      if (($blacklistapps -contains $name)) {
$counter++
      }

      }


      $InstalledSoftware32 = Get-ChildItem "HKLM:\Software\WOW6432NODE\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString, DisplayName_Localized
      foreach($obj32 in $InstalledSoftware32){
         $name32 = $obj32.DisplayName
         if ($null -eq $name32) {
             $name32 = $obj.DisplayName_Localized
         }
         if (($blacklistapps -contains $name32)) {
$counter++
     }
}

if ($counter -eq 0) {
    write-output "Not detected"
    exit 0
}
else {
    write-output "Detected"
    exit 1
}

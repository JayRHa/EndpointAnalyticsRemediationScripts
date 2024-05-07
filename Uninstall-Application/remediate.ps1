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

 $InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString, DisplayName_Localized
 foreach($obj in $InstalledSoftware){
     $name = $obj.DisplayName
     if ($null -eq $name) {
         $name = $obj.DisplayName_Localized
     }
      if (($blacklistapps -contains $name) -and ($null -ne $obj.UninstallString)) {
         $uninstallcommand = $obj.UninstallString
         write-host "Uninstalling $name"
         if ($uninstallcommand -like "*msiexec*") {
         $splitcommand = $uninstallcommand.Split("{")
         $msicode = $splitcommand[1]
         $uninstallapp = "msiexec.exe /X {$msicode /qn"
         start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
         }
         else {
         $splitcommand = $uninstallcommand.Split("{")
        
         $uninstallapp = "$uninstallcommand /S"
         start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
         }
      }

      }


      $InstalledSoftware32 = Get-ChildItem "HKLM:\Software\WOW6432NODE\Microsoft\Windows\CurrentVersion\Uninstall" | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString, DisplayName_Localized
      foreach($obj32 in $InstalledSoftware32){
         $name32 = $obj32.DisplayName
         if ($null -eq $name32) {
             $name32 = $obj.DisplayName_Localized
         }
         if (($blacklistapps -contains $name32) -and ($null -ne $obj32.UninstallString)) {
         $uninstallcommand32 = $obj.UninstallString
         write-host "Uninstalling $name32"
                 if ($uninstallcommand32 -like "*msiexec*") {
         $splitcommand = $uninstallcommand32.Split("{")
         $msicode = $splitcommand[1]
         $uninstallapp = "msiexec.exe /X {$msicode /qn"
         start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
         }
         else {
         $splitcommand = $uninstallcommand32.Split("{")
        
         $uninstallapp = "$uninstallcommand /S"
         start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
         }
     }
}
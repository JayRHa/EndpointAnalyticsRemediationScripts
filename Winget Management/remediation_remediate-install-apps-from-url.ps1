<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: remediate-install-apps-from-url.ps1
Description: Installs apps from a URL via winget
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 
#####################################################################################################################################
#                            LIST URL                                                                                               #
#                                                                                                                               #
#####################################################################################################################################

$installuri = "https://github.com/andrew-s-taylor/winget/raw/main/install-apps.txt"


##Create a folder to store the lists
$AppList = "C:\ProgramData\AppList"
If (Test-Path $AppList) {
    Write-Output "$AppList exists. Skipping."
}
Else {
    Write-Output "The folder '$AppList' doesn't exist. This folder will be used for storing logs created after the script runs. Creating now."
    Start-Sleep 1
    New-Item -Path "$AppList" -ItemType Directory
    Write-Output "The folder $AppList was successfully created."
}

$templateFilePath = "C:\ProgramData\AppList\install-apps.txt"


##Download the list
Invoke-WebRequest `
-Uri $installuri `
-OutFile $templateFilePath `
-UseBasicParsing `
-Headers @{"Cache-Control"="no-cache"}


##Find Winget Path

$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
    if ($ResolveWingetPath){
           $WingetPath = $ResolveWingetPath[-1].Path
    }

$config

##Navigate to the Winget Path
Set-Location $wingetpath

##Loop through app list
$apps = get-content $templateFilePath | select-object -skip 1

##Install each app
foreach ($app in $apps) {

write-host "Installing $app"
.\winget.exe install --exact --id $app --silent --accept-package-agreements --accept-source-agreements
}

##Delete the .old file to replace it with the new one
$oldpath = "C:\ProgramData\AppList\install-apps-old.txt"
If (Test-Path $oldpath) {
    remove-item $oldpath -Force
}

##Rename new to old
rename-item $templateFilePath $oldpath
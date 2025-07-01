<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-install-url-changes.ps1
Description: Detects changes to URL to trigger app install
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



$oldpath = "C:\ProgramData\AppList\install-apps-old.txt"
If (Test-Path $oldpath) {
$newcontent = get-content $templateFilePath | select-object -first 1
$oldcontent = get-content $oldpath | select-object -first 1
If ($newcontent -eq $oldcontent) {
    remove-item -path $templateFilePath -force
    Write-Output "Compliant"
    exit 0
}
else {
    remove-item -path $templateFilePath -force
    Write-Warning "Not Compliant"
    Exit 1

}


}
else {
    remove-item -path $templateFilePath -force
    Write-Warning "Not Compliant"
    Exit 1
}

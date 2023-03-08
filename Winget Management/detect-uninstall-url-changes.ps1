<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-uninstall-url-changes.ps1
Description: Detects changes to URL to uninstall apps via Winget
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
#> 


Function Get-ScriptVersion(){
    
    <#
    .SYNOPSIS
    This function is used to check if the running script is the latest version
    .DESCRIPTION
    This function checks GitHub and compares the 'live' version with the one running
    .EXAMPLE
    Get-ScriptVersion
    Returns a warning and URL if outdated
    .NOTES
    NAME: Get-ScriptVersion
    #>
    
    [cmdletbinding()]
    
    param
    (
        $liveuri
    )
$contentheaderraw = (Invoke-WebRequest -Uri $liveuri -Method Get)
$contentheader = $contentheaderraw.Content.Split([Environment]::NewLine)
$liveversion = (($contentheader | Select-String 'Version:') -replace '[^0-9.]','') | Select-Object -First 1
$currentversion = ((Get-Content -Path $PSCommandPath | Select-String -Pattern "Version: *") -replace '[^0-9.]','') | Select-Object -First 1
if ($liveversion -ne $currentversion) {
write-warning "Script has been updated, please download the latest version from $liveuri"
}
}
Get-ScriptVersion -liveuri "https://raw.githubusercontent.com/andrew-s-taylor/public/main/Powershell%20Scripts/Winget/detect-uninstall-url-changes.ps1"


#####################################################################################################################################
#                            LIST URL                                                                                               #
#                                                                                                                               #
#####################################################################################################################################

$installuri = "https://github.com/andrew-s-taylor/winget/raw/main/uninstall-apps.txt"


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

$templateFilePath = "C:\ProgramData\AppList\uninstall-apps.txt"


##Download the list
Invoke-WebRequest `
-Uri $installuri `
-OutFile $templateFilePath `
-UseBasicParsing `
-Headers @{"Cache-Control"="no-cache"}



$oldpath = "C:\ProgramData\AppList\uninstall-apps-old.txt"
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

<#
Version: 1.0
Author: 
- JOrgen Nilsson (ccmexec.com)
Script: Invoke-FixWindowsUpdateRemediation.ps1
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 
$DependentService = Get-Service -name cryptsvc -DependentServices |where status -eq Started
Stop-Service $DependentService -Force
Get-Service -Name wuauserv | Stop-Service
Get-Service -Name cryptsvc | Stop-Service -Force
Get-Service -Name bits | Stop-Service -Force

if (Test-Path $Env:Windir\SoftwareDistribution.bak) {
     Write-Host "This folder exists"
    Remove-Item $Env:Windir\SoftwareDistribution.bak -Recurse -Force
    Rename-Item -Path $Env:Windir\SoftwareDistribution -NewName SoftwareDistribution.bak
} else {
    Write-Host "This folder doesn't exists!"
    Rename-Item -Path $Env:Windir\SoftwareDistribution -NewName SoftwareDistribution.bak
}

if (Test-Path $Env:Windir\System32\catroot2.bak) {
     Write-Host "This folder exists"
    Remove-Item $Env:Windir\System32\catroot2.bak -Recurse -Force
    Rename-Item -Path $Env:Windir\System32\catroot2 -NewName catroot2.bak
} else {
    Write-Host "This folder doesn't exists!"
    Rename-Item -Path $Env:Windir\System32\catroot2 -NewName catroot2.bak
}

Get-Service -Name cryptsvc | Start-Service
Get-Service -Name bits | Start-Service
Get-Service -Name wuauserv | Start-Service
Start-Service $DependentService

wuauclt /updatenow
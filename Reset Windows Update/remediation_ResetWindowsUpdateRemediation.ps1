<#
Version: 1.0
Author: 
- JOrgen Nilsson (ccmexec.com)
Script: ResetWindowsUpdateRemediation.ps1
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 
$DependentService = Get-Service -name cryptsvc -DependentServices |Where-Object status -eq Started
if ($DependentService) {Stop-Service $DependentService -Force} 
Stop-Service -Name wuauserv 
Stop-Service -Name cryptsvc -Force
Stop-Service -Name bits -Force

if (Test-Path $Env:Windir\SoftwareDistribution.bak) {
    Remove-Item $Env:Windir\SoftwareDistribution.bak -Recurse -Force
    Rename-Item -Path $Env:Windir\SoftwareDistribution -NewName SoftwareDistribution.bak
} else {
    Rename-Item -Path $Env:Windir\SoftwareDistribution -NewName SoftwareDistribution.bak
}

if (Test-Path $Env:Windir\System32\catroot2.bak) {
    Remove-Item $Env:Windir\System32\catroot2.bak -Recurse -Force
    Rename-Item -Path $Env:Windir\System32\catroot2 -NewName catroot2.bak
} else {
    Rename-Item -Path $Env:Windir\System32\catroot2 -NewName catroot2.bak
}

Start-Service -Name cryptsvc 
Start-Service -Name bits 
Start-Service -Name wuauserv 
if ($DependentService) {Start-Service $DependentService}

wuauclt /updatenow
Exit 0
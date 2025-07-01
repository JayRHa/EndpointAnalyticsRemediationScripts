<#
Version: 1.0
Author: 
- Tom Coleman @albanytech
Script: DetectWhoAmiICanaryToken
Description: Detects if canary Token is in Registry
Release notes:
Version 1.0: Init
Run as: Admin/User
Context: 64 Bit
#> 

##Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\wmic.exe"

##Enter the name of the registry key for example EnableLUA
$regname = "GlobalFlag"

##Enter the value of the registry key we are checking for, for example 0
$regvalue = "00000200"


Try {
    $Registry = Get-ItemProperty -Path $regpath -Name $regname -ErrorAction Stop | Select-Object -ExpandProperty $regname
    If ($Registry -eq $regvalue){
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}
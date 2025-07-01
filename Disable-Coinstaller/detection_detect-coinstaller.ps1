<#
Version: 1.0
Author: 
- Adam Gell
Script: detect-coinstaller.ps1
Description: Detects if coinstallers is disabled via registry key
Release notes:
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

##Enter the path to the registry key
$regpath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer"

##Enter the name of the registry key 
$regname = "DisableCoInstallers"

##Enter the value of the registry key
$regvalue = "00000001"


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
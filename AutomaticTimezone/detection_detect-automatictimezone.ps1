<#
Version: 1.0
Author: 
- Adam Gell
Script: detect-automatictimezone.ps1
Description: Sets up Automatic Timezone and Time Sync
Release notes:
Version 1.0: Init
Run as: Admin
Context: 64 Bit
#> 

##Enter the path to the registry key for example HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
$regpath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
$regpath2 = "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate"
##Enter the name of the registry key for example EnableLUA
$regname = "Value"
$regname2 = "start"
##Enter the value of the registry key we are checking for, for example 0
$regvalue = "Allow"
$regvalue2 = "3"


Try {
    $Registry = Get-ItemProperty -Path $regpath -Name $regname -ErrorAction Stop | Select-Object -ExpandProperty $regname
    $Registry2 = Get-ItemProperty -Path $regpath2 -Name $regname2 -ErrorAction Stop | Select-Object -ExpandProperty $regname2
    If (($Registry -eq $regvalue) -and ($Registry2 -eq $regvalue2)) {
        Write-Output "Compliant"
        Exit 0
    }
    else {
        Write-Warning "Not Compliant"
        Exit 1

    }
    

} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}
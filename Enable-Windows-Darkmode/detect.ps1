<#
Version: 1.0
Author: Niklas Rast (niklasrast.com)
Script: detection.ps1
Description: This script checks if the users system theme is set to dark mode or not.
Hint: 
Version: 1.0
Run as: User
Context: 64 Bit
#> 

$regpath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$regname = "AppsUseLightTheme"
$regvalue = "0"

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
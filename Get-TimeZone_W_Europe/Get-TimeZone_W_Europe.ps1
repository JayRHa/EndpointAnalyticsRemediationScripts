<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Detect_TimeZone_W_Europe
Description:
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: Admin
Context: 32 & 64 Bit
#>

$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"
$Name = "TimeZoneKeyName"
$Type = "STRING"
$Value = "W. Europe Standard Time"

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
        Write-Output "Compliant"
        Exit 0
    } 
    else
    {
    Write-Warning "Not Compliant"
    Exit 1
    }
} 
Catch {
    Write-Warning "Not Compliant"
    Exit 1
}
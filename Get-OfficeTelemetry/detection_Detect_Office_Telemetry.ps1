<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: Get-Office_Telemetry
Description: Disable O365 from sharing telemetry
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: User
Context: 32 & 64 Bit
#> 

$Path = "HKCU:\Software\Policies\Microsoft\office\common\clienttelemetry"
$Name = "DisableTelemetry"
$Type = "DWORD"
$Value = 1

Try {
    $Registry = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop | Select-Object -ExpandProperty $Name
    If ($Registry -eq $Value){
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
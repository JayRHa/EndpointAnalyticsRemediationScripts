<#
Version: 1.0
Author: 
- Joey Verlinden (https://www.joeyverlinden.com/)
- Andrew Taylor (https://andrewstaylor.com/)
- Jannik Reinhard (jannikreinhard.com)
Script: detect-cmtrace.ps1
Description: Detects if CMTrace is installed
Release notes:
Version 1.0: Init
#> $Path = "c:\windows\system32\cmtrace.exe"

Try {
    $check = Test-Path -Path $path -ErrorAction Stop
    If ($check -eq $true){
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
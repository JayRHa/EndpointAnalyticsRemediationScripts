<#
Version: 1.0
Author: 
- Joey Verlinden (joeyverlinden.com)
- Andrew Taylor (andrewstaylor.com)
- Florian Slazmann (scloud.work)
- Jannik Reinhard (jannikreinhard.com)
Script: winget-upgrade-remediate.ps1
Description: Updates all apps via Winget
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#> 

$Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\winget.exe") |
    Sort-Object { [version](($_.FullName -split '_')[1]) } -ErrorAction SilentlyContinue |
    Select-Object -Last 1 -ExpandProperty FullName

if (-not $Winget) {
    $Winget = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $env:ProgramFiles -ChildPath "WindowsApps") -ChildPath "Microsoft.DesktopAppInstaller*_x64*\AppInstallerCLI.exe") |
        Sort-Object LastWriteTime |
        Select-Object -Last 1 -ExpandProperty FullName
}

&$Winget upgrade --all --force --silent
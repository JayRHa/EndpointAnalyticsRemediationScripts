<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: fix-searchindex.ps1
Description: Rebuilds the Windows Search index
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    Stop-Service -Name WSearch -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 3

    $IndexPath = "$env:ProgramData\Microsoft\Search\Data\Applications\Windows"
    if (Test-Path $IndexPath) {
        Remove-Item -Path "$IndexPath\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows Search"
    New-ItemProperty -Path $RegPath -Name "SetupCompletedSuccessfully" -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null

    Start-Service -Name WSearch -ErrorAction Stop
    Write-Output "Windows Search index rebuild initiated"
    exit 0
}
catch {
    Start-Service -Name WSearch -ErrorAction SilentlyContinue
    Write-Error "Failed to rebuild search index: $_"
    exit 1
}

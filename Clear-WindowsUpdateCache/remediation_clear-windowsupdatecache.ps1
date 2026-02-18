<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: clear-windowsupdatecache.ps1
Description: Clears the Windows Update download cache
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Stop-Service -Name bits -Force -ErrorAction SilentlyContinue

    $CachePath = "$env:SystemRoot\SoftwareDistribution\Download"
    if (Test-Path $CachePath) {
        Remove-Item -Path "$CachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Start-Service -Name bits -ErrorAction SilentlyContinue

    Write-Output "Windows Update cache cleared successfully"
    exit 0
}
catch {
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Start-Service -Name bits -ErrorAction SilentlyContinue
    Write-Error "Failed to clear Windows Update cache: $_"
    exit 1
}

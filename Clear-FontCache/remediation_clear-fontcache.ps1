<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: clear-fontcache.ps1
Description: Clears the Windows font cache
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

try {
    Stop-Service -Name "FontCache" -Force -ErrorAction SilentlyContinue
    Stop-Service -Name "FontCache3.0.0.0" -Force -ErrorAction SilentlyContinue

    $FontCachePath = "$env:SystemRoot\ServiceProfiles\LocalService\AppData\Local\FontCache"
    if (Test-Path $FontCachePath) {
        Remove-Item -Path "$FontCachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    $FontCacheFile = "$env:SystemRoot\System32\FNTCACHE.DAT"
    if (Test-Path $FontCacheFile) {
        Remove-Item -Path $FontCacheFile -Force -ErrorAction SilentlyContinue
    }

    Start-Service -Name "FontCache" -ErrorAction SilentlyContinue

    Write-Output "Font cache cleared successfully. A reboot may be required."
    exit 0
}
catch {
    Start-Service -Name "FontCache" -ErrorAction SilentlyContinue
    Write-Error "Failed to clear font cache: $_"
    exit 1
}

<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-fontcache.ps1
Description: Detects if the font cache is larger than 100MB
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxSizeMB = 100

try {
    $FontCachePath = "$env:SystemRoot\ServiceProfiles\LocalService\AppData\Local\FontCache"
    $FontCacheFile = "$env:SystemRoot\System32\FNTCACHE.DAT"

    $TotalSize = 0
    if (Test-Path $FontCachePath) {
        $TotalSize += (Get-ChildItem -Path $FontCachePath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    }
    if (Test-Path $FontCacheFile) {
        $TotalSize += (Get-Item $FontCacheFile -ErrorAction SilentlyContinue).Length
    }

    $SizeMB = [math]::Round($TotalSize / 1MB, 2)
    if ($SizeMB -gt $MaxSizeMB) {
        Write-Warning "Not Compliant - Font cache is $SizeMB MB"
        exit 1
    }

    Write-Output "Compliant - Font cache is $SizeMB MB"
    exit 0
}
catch {
    Write-Warning "Error checking font cache: $_"
    exit 1
}

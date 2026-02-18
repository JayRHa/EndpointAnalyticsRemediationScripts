<#
Version: 1.0
Author: Jannik Reinhard (jannikreinhard.com)
Script: detect-windowsupdatecache.ps1
Description: Detects if Windows Update cache is larger than 1GB
Hint: This is a community script. There is no guarantee for this. Please check thoroughly before running.
Version 1.0: Init
Run as: System
Context: 64 Bit
#>

$MaxSizeMB = 1024

try {
    $CachePath = "$env:SystemRoot\SoftwareDistribution\Download"
    if (Test-Path $CachePath) {
        $Size = (Get-ChildItem -Path $CachePath -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $SizeMB = [math]::Round($Size / 1MB, 2)

        if ($SizeMB -gt $MaxSizeMB) {
            Write-Warning "Not Compliant - Windows Update cache is $SizeMB MB"
            exit 1
        }
    }

    Write-Output "Compliant - Windows Update cache is within limits"
    exit 0
}
catch {
    Write-Warning "Error checking Windows Update cache: $_"
    exit 1
}
